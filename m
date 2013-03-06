Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab3CFQ7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:59:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45393 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851Ab3CFQ7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:59:37 -0500
Message-ID: <51377566.6060907@zytor.com>
Date: Wed, 06 Mar 2013 08:57:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Henrik Rydberg <rydberg@euromail.se>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: Linux 3.9-rc1
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com> <20130306080642.GA535@polaris.bitmath.org> <CA+55aFxkDRoNEEw+8RwrSCsRUCUcRbEE57hzFQ8dPUXT2CWMog@mail.gmail.com>
In-Reply-To: <CA+55aFxkDRoNEEw+8RwrSCsRUCUcRbEE57hzFQ8dPUXT2CWMog@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 08:08 AM, Linus Torvalds wrote:
> On Wed, Mar 6, 2013 at 12:06 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>>
>> Or not. ;-) This commit breaks boot on my MacBookAir3,1:
>>
>> commit 8d57470d8f859635deffe3919d7d4867b488b85a
>> Author: Yinghai Lu <yinghai@kernel.org>
>> Date:   Fri Nov 16 19:38:58 2012 -0800
>>
>>     x86, mm: setup page table in top-down
> 
> Argh. The whole page table setup crud is scarily fragile.
> 

Yes.  The design of the new code should be much more robust by design,
but of course all the corner cases got shifted around...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

