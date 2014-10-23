Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543AbaJWA3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 20:29:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15453 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbaJWA3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 20:29:08 -0400
X-AuditID: cbfee691-f79b86d000004a5a-13-54484bd1793e
Date: Thu, 23 Oct 2014 00:29:05 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: Re: Re: [PATCH] mips: add arch_trigger_all_cpu_backtrace() function
To: James Hogan <james.hogan@imgtec.com>
Cc: "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20141023002307469@eunb.song
Msgkey: 20141023002307469@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141023002307469@eunb.song
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <863134949.204101414024143724.JavaMail.weblogic@epmlwas06c>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsVy+t8zHd2L3h4hBue3iVtc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXMWPPzOXPBP46K3V9OMTcw3uHoYuTkEBJQkWj5/50RxJYQMJG4cvEh
	O4QtJnHh3nq2LkYuoJpljBLvft2BK5p+6hEjRGIOo8SCF/1MIAkWAVWJ9y9egnWzCWhL/Dhw
	lRnEFhbwkdgz/SNYs4iAlkTji5fMIM3MAqsZJd5s7mOFOENeYvLpy2DNvAKCEidnPmHpYuQA
	2qYkcfulA0RYWWLfxgYWiCMkJGZNv8AKYfNKzGh/ChWXk5j2dQ0zhC0tcX7WBkaYbxZ/fwwV
	55c4dnsHE4QtIDH1zEGoGnWJplnv2SBsPok1C99CzRSUOH2tmxlm1/0tc5lgbtja8gTsBmYB
	RYkp3ZCQYwb68cuPfWyoXgGx3SXWvX4GDlEJgZkcEiev9DFPYFSahaRuFpJZs5DMQlazgJFl
	FaNoakFyQXFSepEpcnxvYoQkw4k7GO8fsD7EKMDBqMTD68DmHiLEmlhWXJl7iDEZGE8TmaVE
	k/OBKTevJN7Q2MzIwtTE1NjI3NIMQ9jE1MLCxAiHsJI4r470z2AhgfTEktTs1NSC1KL4otKc
	1OJDjEwcnFINjJpaPFder85YtMpytix7rlzXumWL/+dktxXsk4zccmR5642LLYLtW9Sf7zwc
	w56bWvwzI2CPIMNvh4fb6jIOxjb2xT+d8Miab0rA3FUyX+6u/VDT5s+WtflbSd31l8vnehn+
	vNsVmuF1sYpXr7rnkPQ7syILsdY/znO8l+y3ShfvZXub8Wh/uBJLcUaioRZzUXEiAC289hSv	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t/tPt2L3h4hBtveilhc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jDU/nzMX/OOo2P3lFHMD4x2OLkZODiEBFYmW/98ZQWwJAROJ6aceQdliEhfurWfrYuQCqpnD
	KLHgRT8TSIJFQFXi/YuX7CA2m4C2xI8DV5lBbGEBH4k90z+CNYsIaEk0vnjJDNLMLLCaUeLN
	5j5WiG3yEpNPXwZr5hUQlDg58wlLFyMH0DYlidsvHSDCyhL7NjawQBwhITFr+gVWCJtXYkb7
	U6i4nMS0r2uYIWxpifOzNsAdvfj7Y6g4v8Sx2zuYIGwBialnDkLVqEs0zXrPBmHzSaxZ+BZq
	pqDE6WvdzDC77m+ZywRzw9aWJ2A3MAsoSkzpfsgOYWtJfPmxjw3VKyC2u8S618/YJjDKzkKS
	moWkfRaSdmQ1CxhZVjGKphYkFxQnpVcY6RUn5haX5qXrJefnbmIEJ6Nni3Yw/jtvfYhRgINR
	iYd3Bod7iBBrYllxZe4hRgkOZiUR3lprjxAh3pTEyqrUovz4otKc1OJDjKbAWJvILCWanA9M
	lHkl8YbGBsaGhpbmBqaGRhZK4rzyt5KChATSE0tSs1NTC1KLYPqYODilGhhrf7ZOq14kPO+K
	5tv0Uw//1XIJeTH6m/8V7dxWdO67d5TSDbPLKadl2N7cnFn/Mzzr+mUFXeZ3glFf/92+56O/
	NLixwfX/jF1VlwVerH+gLHqg6NeNZTFhh7jtd+7/ve3gNrlcpqMrt9YcbVxjF/FgZXnO+k3P
	v33yb37B0rWg54rUlDdqf9/JKrEUZyQaajEXFScCAHFs2g1cAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9N0TGhg012024



>> This patch adds arch_trigger_all_cpu_backtrace() for mips architecture.

> Don't forget your Signed-off-by

I'm sorry fot this. 

>> +static void arch_dump_stack(void *info)
>> +{
>> + struct pt_regs *regs;  
>> + 
>> + regs = get_irq_regs();
>> +
>> + if(regs)
>> + show_regs(regs);
>> +
>> + dump_stack();
>> +}
>> +
>> +void arch_trigger_all_cpu_backtrace(bool include_self)
>> +{
>> + smp_call_function(arch_dump_stack, NULL, 1);

> should this call arch_dump_stack directly too if include_self?
Currently, in case of mips there is no case include_self is true, so this is not a problem. 
arch_trigger_all_cpu_backtrace can only be called from trigger_allbutself_cpu_backtrace() in kernel/watchdog.c.
But as you said, if the case will be added, we should consider that.

Thanks.

> Cheers
> JamesˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
