Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3CVAmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:42:03 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:33422 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab3CVAmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:42:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
References: <20130321.115920.339923125.d.hatayama@jp.fujitsu.com>
	<87r4j98l1q.fsf@xmission.com> <20130321143656.GG3934@redhat.com>
	<20130322.093042.393566604.d.hatayama@jp.fujitsu.com>
Date: Thu, 21 Mar 2013 17:41:51 -0700
In-Reply-To: <20130322.093042.393566604.d.hatayama@jp.fujitsu.com> (HATAYAMA
	Daisuke's message of "Fri, 22 Mar 2013 09:30:42 +0900 (JST)")
Message-ID: <87r4j8p8og.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19rc/fOWdXUUYnmnGhtPV6A3Ijo7nC2LRs=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 17/21] vmcore: check NT_VMCORE_PAD as a mark indicating the end of ELF note buffer
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:

> From: Vivek Goyal <vgoyal@redhat.com>
> Subject: Re: [PATCH v3 17/21] vmcore: check NT_VMCORE_PAD as a mark indicating the end of ELF note buffer
> Date: Thu, 21 Mar 2013 10:36:56 -0400
>
>> And in our case we don't know the size of ELF note. Kernel is not
>> exporting the size. So kexec-tools is putting an upper limit of 1024
>> and putting that value in p_memsz and p_filesz fields.
>> 
>> Given the fact that we are reserving elf notes at boot. That means
>> we know the size of ELF notes. It should make sense to export it
>> to user space and let kexec-tools put right values.
>> 
>
> Anyway, I think of this issue as beyond the scope of what I'm working
> here...

Agreed.  It is independent and can be fixed independently.

Eric
