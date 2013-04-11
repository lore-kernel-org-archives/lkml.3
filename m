Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763205Ab3DKWxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 18:53:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48244 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759177Ab3DKWxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 18:53:07 -0400
Message-ID: <51673E8C.9080806@zytor.com>
Date: Thu, 11 Apr 2013 15:51:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Early microcode signing in secure boot environment -  Was: x86,
 microcode: Use common get_ramdisk_image()
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org> <1478755.iNa1PauEka@skinner.arch.suse.de> <3E5A0FA7E9CA944F9D5414FEC6C712205594C20D@ORSMSX105.amr.corp.intel.com> <195101369.cgl3lvkTHk@skinner.arch.suse.de>
In-Reply-To: <195101369.cgl3lvkTHk@skinner.arch.suse.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 01:59 AM, Thomas Renninger wrote:
> 
>>> Is this "cryptographically authenticated by the CPU itself" thing
>>> documented
>>> somewhere so that security people can double check that it is really
>>> secure?
>>
>> X86 SDM defines that the second part of microcode update is the encrypted
>> data.
> 
> Again, I doubt it is allowed to bypass UEFI authentication with arbitrary, 
> vendor specific authentication checks.
> 

What does that even mean in this context?

	-hpa


