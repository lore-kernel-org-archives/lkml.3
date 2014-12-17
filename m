Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbaLQCqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 21:46:18 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:46948 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaLQCqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 21:46:15 -0500
X-AuditID: cbfee691-f79b86d000004a5a-11-5490ee7515dd
Date: Wed, 17 Dec 2014 02:46:13 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: Re: Re: [3.18+] Can't boot with commit bd809af1
 ("x86: Enable PAT to use cache mode translation tables")
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Peter Hurley <peter@hurleysoftware.com>, Juergen Gross <jgross@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20141217024419374@jongman.heo
Msgkey: 20141217024419374@jongman.heo
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141217024419374@jongman.heo
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <1333823854.228911418784371728.JavaMail.weblogic@epmlwas04b>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWyRsSkWLf03YQQg+PtshaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvjxP0XjAVtERXTz/1jaWB8ENrFyMkhJKAmcfPzIUYQW0LARGLh
	rANQtpjEhXvr2boYuYBqljJKND7ezQRTtPbpd3aIxBxGieWrz4AlWARUJY5e6WAHsdkEdCQ6
	/u9nBbGFBQolDj78DjSVg0NEQE/iSAMXSC+zwGRGie5PF1kgrlCUuLZ0MRuIzSsgKHFy5hMW
	iGUqEncv9jJDxFUlTi99yQoRl5CYNf0ClM0rMaP9KVS9nMS0r2uYIWxpifOzNsB9s/j7Y6g4
	v8Sx2zugnhGQmHrmIFSNpsSSyeegbD6JNQvfssDU7zq1nBlm1/0tc5lgbtja8gTsBmag+6d0
	P2SHsLUkvvzYh+EXXgEPiZ7zp6Bu7uWQOHiKbQKj0iwkZbOQjJqFZBSymgWMLKsYRVMLkguK
	k9KLTPWKE3OLS/PS9ZLzczcxAlPD6X/PJu5gvH/A+hCjAAejEg/vhKsTQoRYE8uKK3MPMZoC
	o2kis5Rocj4wAeWVxBsamxlZmJqYGhuZW5opifPqSP8MFhJITyxJzU5NLUgtii8qzUktPsTI
	xMEp1cAY//LP2wyHfUrZlZ2aE16o3vkpvF3ils/LrlqLc7PDZn7/KvXqzjmtS78k30xdLfS+
	yiRfcOp014uWx/VumVZsuvPjync3R/N7N18eylnPdF9A+/qnRUF/tuyWSl5zbuutN/3vOx4o
	nune0HXVTd6O/wFH3NaPLtNllxddEeGQCLFZzvn3IUsWrxJLcUaioRZzUXEiAEJhduAIAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t/tXt3SdxNCDHZdEbG4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRkn
	7r9gLGiLqJh+7h9LA+OD0C5GTg4hATWJm58PMYLYEgImEmuffmeHsMUkLtxbz9bFyAVUM4dR
	YvnqM0wgCRYBVYmjVzrAitgEdCQ6/u9nBbGFBQolDj78DjSIg0NEQE/iSAMXSC+zwGRGie5P
	F1kglilKXFu6mA3E5hUQlDg58wkLxDIVibsXe5kh4qoSp5e+ZIWIS0jMmn4ByuaVmNH+FKpe
	TmLa1zXMELa0xPlZGxhhjl78/TFUnF/i2O0dTBC2gMTUMwehajQllkw+B2XzSaxZ+JYFpn7X
	qeXMMLvub5nLBHPD1pYnYDcwA90/pfshO4StJfHlxz4Mv/AKeEj0nD/FOoFRdhaS1Cwk7bOQ
	tCOrWcDIsopRNLUguaA4Kb3CWK84Mbe4NC9dLzk/dxMjOBE9W7yD8f9560OMAhyMSjy8L65P
	CBFiTSwrrsw9xCjBwawkwmuxCCjEm5JYWZValB9fVJqTWnyI0RQYaxOZpUST84FJMq8k3tDY
	2MTMxNTSxMLA1FxJnPf/udwQIYH0xJLU7NTUgtQimD4mDk6pBkbR1w3LS0+cXLq7vuDMf1+9
	1qtB+yIF/RQYeCbP7JFM7pazOFg7v3Otno3el7L4CE2uL6/MW3ufGljpeyUt6ZF8UPEpYFvh
	g9k/4/g8tmf1apz4nOQrtOFckbBGQ9FMJqeSeQuk/H+xiAq1rTlhYNWoGFK/rjb/E0e6CFv6
	5MLpS5rY9/07pMRSnJFoqMVcVJwIAEu62NlaAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBH2kUfc008854


Hi,

I'm using VMWare workstation, version 10.0.3 build-1895310, on Windows 7 64-bit.
Guest is Fedora 21.

------- Original Message -------
Sender : Thomas Hellstrom<thellstrom@vmware.com>
Date : 2014-12-17 00:12 (GMT+09:00)
Title : Re: [3.18+] Can't boot with commit bd809af1 ("x86: Enable PAT to use cache mode translation tables")

Jongman, what product (player, ws, esx) and version are you using?

Thanks,
Thomas


On 12/16/2014 02:08 PM, Peter Hurley wrote:
> VMware guys probably already know this but just in case
>
> [ +cc Thomas Hellstrom ]
>
> Jongman - you need to fix your mailer to use plaintext and not base64.
>
> On 12/16/2014 01:46 AM, Jongman Heo wrote:
>>> Sender : Juergen Gross
>>> On 12/16/2014 07:29 AM, Jongman Heo wrote:
>>>>> Sender : Juergen Gross
>>>>> On 12/16/2014 05:40 AM, Jongman Heo wrote:
>>>>>>> Sender : Juergen Gross
>>>>>>> On 12/15/2014 08:52 AM, Jongman Heo wrote:
>>>>>>>>> Sender : Juergen Gross
>>>>>>>>> On 12/14/2014 06:07 AM, «„¡æ∏∏ wrote:
>>>>>>>>>> Hi,
>>>>>>>>>>
>>>>>>>>>> My Linux virtual machine on (Windows) VMWare workstation 10 can't boot with following commit.
>>>>>>>>>>
>>>>>>>>>> commit bd809af16e3ab1f8d55b3e2928c47c67e2a865d2
>>>>>>>>>> Author: Juergen Gross
>>>>>>>>>> Date:   Mon Nov 3 14:02:03 2014 +0100
>>>>>>>>>>
>>>>>>>>>>         x86: Enable PAT to use cache mode translation tables
>>>>>>>>>>
>>>>>>>>>> Unfortunately I can't see any console log.
>>>>>>>>> Hmm, weird. Could you provide some more information?
>>>>>>>>>
>>>>>>>>> Kernel config, hardware used, /proc/cpuinfo of working kernel?
>>>>>>>>> Anything you see with earlyprintk enabled?
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Juergen
>>>>>>>> (Sorry for resending this email, previous one bounced from mailing list due to HTML format)
>>>>>>>>
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> I'm using Fedora 21, with custom built kernel.
>>>>>>>> Host PC is windows 7 64-bit, and running VMWare workstation 10 for guest Fedora Linux.
>>>>>>>>
>>>>>>>> With earlyprintk, just following message is printed.
>>>>>>>>
>>>>>>>>      early console in setup code
>>>>>>>>
>>>>>>>> and nothing more...
>>>>>>> Can you try attached diagnostic patch, please? I suspect a problem
>>>>>>> regarding VMWares PAT emulation...
>>>>>>>
>>>>>>>
>>>>>>> Juergen
>>>>>> Hi,
>>>>>>
>>>>>> With the commit reverted, the patch doesn't apply.
>>>>> Sure.
>>>>>
>>>>>> Without revert, kernel (patch applied) doesn't boot and I can't see any message.
>>>>> What are your kernel parameters? There must be some message with the
>>>>> diagnostic patch, as the first pr_info() is called before any other
>>>>> part of the critical patch is becoming active. Could it be you have
>>>>> instructed the kernel to be "quiet"? I'd recommend:
>>>>>
>>>>> earlyprintk=vga ignore_loglevel
>>>>>
>>>>> and no quiet. I don't know VMWare settings, so may be you can use
>>>>> earlyprintk=ttyS0 instead of vga.
>>>>>
>>>>>> Let me show you my PAT values (the commit reverted)
>>>>>>
>>>>>> # dmesg | grep PAT
>>>>>> [    0.000000] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
>>>>>> [    0.314631] x86 PAT enabled: cpu 3, old 0x0, new 0x7010600070106
>>>>>> [    0.314703] x86 PAT enabled: cpu 1, old 0x0, new 0x7010600070106
>>>>>> [    0.314780] x86 PAT enabled: cpu 2, old 0x0, new 0x7010600070106
>>>>>> [    0.314852] x86 PAT enabled: cpu 4, old 0x0, new 0x7010600070106
>>>>>> [    0.314923] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
>>>>>> [    0.314997] x86 PAT enabled: cpu 6, old 0x0, new 0x7010600070106
>>>>>> [    0.315069] x86 PAT enabled: cpu 7, old 0x0, new 0x7010600070106
>>>>>> [    0.315142] x86 PAT enabled: cpu 5, old 0x0, new 0x7010600070106
>>>>> These are the expected values. But these values are the ones which are
>>>>> written, not the ones which have been read from the PAT MSR again.
>>>>>
>>>>> Without applying the critical patch you could add:
>>>>>
>>>>> rdmsrl(MSR_IA32_CR_PAT, pat);
>>>>> printk(KERN_INFO "PAT read: cpu %d, 0x%Lx\n", smp_processor_id(), pat);
>>>>>
>>>>> at the end of pat_init() to verify VMWare is handling reads of the PAT
>>>>> MSR properly.
>>>>>
>>>>> Juergen
>>>>>
>>>> Hi,
>>>>
>>>> With earlyprintk=vga, I can see the log.
>>>> But due to call trace, I can't see what the pat value is.
>>>>
>>>> Call chain is as follows.
>>>>
>>>>    i386_start_kernel -> start_kernel -> setup_arch ->
>>>>    mtrr_bp_init -> get_mtrr_state -> pat_init ->
>>>>    pat_init_cache_mode_entry -> update_cache_mode_entry ->
>>>>    early_idt_handler -> dump_stack
>>>>
>>>> So, I blocked update_cache_mode_entry() call like below...
>>>>
>>>> --- a/arch/x86/mm/pat.c
>>>> +++ b/arch/x86/mm/pat.c
>>>> @@ -182,11 +182,12 @@ void pat_init_cache_modes(void)
>>>>          u64 pat;
>>>>   
>>>>          rdmsrl(MSR_IA32_CR_PAT, pat);
>>>> +       pr_info("read pat %0llx\n", pat);
>>>>          pat_msg[32] = 0;
>>>>          for (i = 7; i >= 0; i--) {
>>>>                  cache = pat_get_cache_mode((pat >> (i * 8)) & 7,
>>>>                                             pat_msg + 4 * i);
>>>> -               update_cache_mode_entry(i, cache);
>>>> +               //update_cache_mode_entry(i, cache);
>>>>          }
>>>>          pr_info("PAT configuration [0-7]: %s\n", pat_msg);
>>>>   }
>>>> @@ -238,9 +239,13 @@ void pat_init(void)
>>>>                  rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
>>>>   
>>>>          wrmsrl(MSR_IA32_CR_PAT, pat);
>>>> +       pr_info("about to write pat %0llx\n", pat);
>>>>   
>>>>          if (boot_cpu)
>>>>                  pat_init_cache_modes();
>>>> +
>>>> +       rdmsrl(MSR_IA32_CR_PAT, pat);
>>>> +       printk(KERN_INFO "PAT read: cpu %d, 0x%Lx\n", smp_processor_id(), pat);
>>>>   }
>>>>   
>>>>
>>>> Then boot is fine, and PAT values are as follows.
>>>>
>>>>
>>>> # dmesg|grep -i "pat "
>>>> [    0.000000] about to write pat 7010600070106
>>>> [    0.000000] read pat 0
>>>> [    0.000000] PAT configuration [0-7]: UC  UC  UC  UC  UC  UC  UC  UC
>>>> [    0.000000] PAT read: cpu 0, 0x0
>>>> [    0.320559] about to write pat 7010600070106
>>>> [    0.320876] read pat 0
>>>> [    0.321090] PAT configuration [0-7]: UC  UC  UC  UC  UC  UC  UC  UC
>>>> [    0.321260] PAT read: cpu 5, 0x0
>>>> [    0.321403] about to write pat 7010600070106
>>>> [    0.321818] read pat 0
>>>> [    0.322033] PAT configuration [0-7]: UC  UC  UC  UC  UC  UC  UC  UC
>>>> [    0.322205] PAT read: cpu 6, 0x0
>>>> [    0.322334] about to write pat 7010600070106
>>>> [    0.322417] read pat 0
>>>> [    0.322479] PAT configuration [0-7]: UC  UC  UC  UC  UC  UC  UC  UC
>>>> [    0.322573] PAT read: cpu 0, 0x0
>>>> [    0.322703] about to write pat 7010600070106
>>>> [    0.323012] read pat 0
>>>> [    0.323228] PAT configuration [0-7]: UC  UC  UC  UC  UC  UC  UC  UC
>>>> [    0.323400] PAT read: cpu 1, 0x0
>>>> [    0.323537] about to write pat 7010600070106
>>>> [    0.323833] read pat 0
>>>> [    0.324055] PAT configuration [0-7]: UC  UC  UC  UC  UC  UC  UC  UC
>>>> [    0.324224] PAT read: cpu 7, 0x0
>>>> [    0.324362] about to write pat 7010600070106
>>>> [    0.324662] read pat 0
>>>> [    0.324877] PAT configuration [0-7]: UC  UC  UC  UC  UC  UC  UC  UC
>>>> [    0.325048] PAT read: cpu 2, 0x0
>>>> [    0.325185] about to write pat 7010600070106
>>>> [    0.325483] read pat 0
>>>> [    0.325695] PAT configuration [0-7]: UC  UC  UC  UC  UC  UC  UC  UC
>>>> [    0.325863] PAT read: cpu 4, 0x0
>>>> [    0.325997] about to write pat 7010600070106
>>>> [    0.326288] read pat 0
>>>> [    0.326507] PAT configuration [0-7]: UC  UC  UC  UC  UC  UC  UC  UC
>>>> [    0.326677] PAT read: cpu 3, 0x0
>>> Okay, so VMWare doesn't seem to return the correct PAT MSR value.
>>>
>>> I suggest you try "nopat" as kernel option. This should disable all the
>>> PAT handling and VMWare can't wreck the kernel this way.
>>>
>>> I'll write a patch which detects this VMWare bug by checking the PAT
>>> value after writing it.
>>>
>>> Thanks for reporting that case,
>>>
>>>
>>> Juergen
>>>
>>>
>> OK, my VMWare works with "nopat" option.
>>
>> Thanks~.N
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
