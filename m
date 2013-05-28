Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964833Ab3E1RgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 13:36:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52707 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964784Ab3E1RgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 13:36:09 -0400
Message-ID: <51A4EADB.9080703@zytor.com>
Date: Tue, 28 May 2013 10:35:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Simon Horman <horms@verge.net.au>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>
Subject: Re: [PATCH v2 2/7] Documentation/devices.txt: Mark /dev/oldmem obsolete
References: <1369721851.2776.37@driftwood> <51A44DD5.5050301@cn.fujitsu.com> <1369761966.2776.39@driftwood>
In-Reply-To: <1369761966.2776.39@driftwood>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 10:26 AM, Rob Landley wrote:
>>
>> So, could I just use UNSED to replace OBSOLETE here? Or use
>> "OBSOLETE/UNUSED"?
> 
> Obsolete is fine.
> 
> Obsolete means it was used at some point, and thus reusing it might
> confuse or conflcit with legacy software. Unused could just mean that we
> left a gap for some reason, it doesn't imply it ever was used.
> 
> Explicitly documenting "unused" is kind of silly: all the ones we
> _don't_ document are presumably unused. Obsolete carries with it a very
> mild warning about legacy software, which is presumably why we still
> bother to mention it at all instead of just removing the entry.
> 
> (Then again the point was that nothing ever used this interface in the
> first place. Personally I'd just have removed the entry...)
> 

"Obsolete" in this specific context means that the reservation is
obsolete, but was used in kernels past, therefore the name and number
should not be reused to prevent old software from misbehaving.

	-hpa


