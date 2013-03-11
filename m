Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab3CKEOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 00:14:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35741 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab3CKEOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 00:14:15 -0400
Message-ID: <513D5962.7000209@zytor.com>
Date: Sun, 10 Mar 2013 21:11:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: ebiederm@xmission.com, len.brown@intel.com, fenghua.yu@intel.com,
        x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, tglx@linutronix.de, mingo@elte.hu,
        vgoyal@redhat.com
Subject: Re: [PATCH v1 2/2] x86, apic: Disable BSP if boot cpu is AP
References: <20121026.122406.13396329.d.hatayama@jp.fujitsu.com> <87r4oloopm.fsf@xmission.com> <20130311.100721.32982204.d.hatayama@jp.fujitsu.com> <20130311.111352.105946462.d.hatayama@jp.fujitsu.com>
In-Reply-To: <20130311.111352.105946462.d.hatayama@jp.fujitsu.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2013 07:13 PM, HATAYAMA Daisuke wrote:
> 
> It seems to me that at least there needs to be the following design
> policy for multiple CPUs on the 2nd kenrel:
> 
> - There's no firmware, kernel components and modules that depend on
>   BSP flag being kept set on the original BSP flag and never set BSP
>   flag of any of the existing CPUs again at runtime.
> 

And that is provably false in the case of firmware.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

