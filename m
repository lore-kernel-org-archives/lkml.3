Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237Ab3CGPGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:06:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56116 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907Ab3CGPGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:06:19 -0500
Message-ID: <5138ACE2.9030105@zytor.com>
Date: Thu, 07 Mar 2013 07:06:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: linux-kernel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: 3.9-rc1: hz.bc compilation breakage
References: <5137546B.2090801@free-electrons.com> <51380C65.50202@zytor.com> <51386F0D.8060105@free-electrons.com>
In-Reply-To: <51386F0D.8060105@free-electrons.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 02:42 AM, Maxime Ripard wrote:
> 
> I triggered this issue when switching to 3.9-rc1, and oldconfig runs at
> that time, and now, running menuconfig doesn't generates it either.
> 
>> I am not sure what you mean with "clean out-of-tree", however.
> 
> make O=$(pwd) -C /path/to/linux/source some_configs
> make
> 

Can you give the exact set of commands you are running when you see
this?  I cannot reproduce this no matter what I do, and it doesn't seem
like it is being a common problem.

In the example above the first "make" command does indeed not create any
files in include/config, but they get created immediately on the second
"make"...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

