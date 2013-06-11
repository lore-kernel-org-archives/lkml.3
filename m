Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab3FKFTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 01:19:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39485 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab3FKFTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 01:19:48 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-6b-51b6b3737238
Message-id: <51B6B373.7040904@samsung.com>
Date: Tue, 11 Jun 2013 14:19:47 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RESEND][PATCH] cpufreq: stats: Add 'load_table' sysfs file to
 show accumulated data of CPU
References: <1370419882-16831-1-git-send-email-cw00.choi@samsung.com>
 <CAKohpon6fgft2KZgy3-w5TxDz=5JsVHhNdTPTF7ZUq9K-kGc3w@mail.gmail.com>
 <51B5C2E4.9060400@samsung.com>
 <CAKohpokSt1=cbeYFo-U_DF5Mr8WOFDkkQbyaHh5DqR0OHh+S7A@mail.gmail.com>
In-reply-to: <CAKohpokSt1=cbeYFo-U_DF5Mr8WOFDkkQbyaHh5DqR0OHh+S7A@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsWyRsSkRLd487ZAg4+T2S2eNv1gtzjb9Ibd
	4v2hZ8wWl3fNYbP43HuE0eJ24wo2i/6FvUwWG796OHB43Lm2h83j9r/HzB59W1Yxejxa3MLo
	8XmTXABrFJdNSmpOZllqkb5dAlfGkdPHGAs+cVccnLeZtYFxI2cXIyeHhICJRO/qR0wQtpjE
	hXvr2boYuTiEBJYySvz89Ysdpmjb7QtQiUWMEsc6D7BDOC8YJZa/aGAFqeIV0JI4u/4qG4jN
	IqAq8WjnLjCbDSi+/8UNMFtUIExi5fQrLBD1ghI/Jt8Dsjk4RIBqXt5MBZnJLHCeUWL3/3PM
	IDXCAlkSy+b9BpsvJPCFUWLXUiUQm1MgWKJ923KwGmYBHYn9rdPYIGx5ic1r3jKDDJIQuMYu
	caLhLCPEQQIS3yYfAlsmISArsekAM8RnkhIHV9xgmcAoNgvJSbOQjJ2FZOwCRuZVjKKpBckF
	xUnpRSZ6xYm5xaV56XrJ+bmbGIERePrfswk7GO8dsD7EmAy0ciKzlGhyPjCC80riDY3NjCxM
	TUyNjcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAWGLN41ic1MEizy1+
	/4KXu8bu3hetb38vnVhwQf2CyneRoHevzSS//zLb2qPkIPeD03OmyY/qfNser/Bjs9jYw55w
	r5hgx2xyvWHBbFHN1z+nJ9ycvOTMuuY21SUmy3d8nvtqndChitNR58sPpB6dFXPJfV9fpZzR
	hpovRjFC/Qp8z1dVTy6pVWIpzkg01GIuKk4EAMS34gnWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jAd2izdsCDWY/tbJ42vSD3eJs0xt2
	i/eHnjFbXN41h83ic+8RRovbjSvYLPoX9jJZbPzq4cDhcefaHjaP2/8eM3v0bVnF6PFocQuj
	x+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+Abpu
	mTlAtygplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM46cPsZY8Im74uC8
	zawNjBs5uxg5OSQETCS23b7ABmGLSVy4tx7I5uIQEljEKHGs8wA7hPOCUWL5iwZWkCpeAS2J
	s+uvgnWwCKhKPNq5C8xmA4rvf3EDzBYVCJNYOf0KC0S9oMSPyfeAbA4OEaCalzdTQWYyC5xn
	lNj9/xwzSI2wQJbEsnm/weYLCXxhlNi1VAnE5hQIlmjfthyshllAR2J/6zQ2CFteYvOat8wT
	GAVmIVkxC0nZLCRlCxiZVzGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEx/czqR2MKxssDjEK
	cDAq8fAmMG4LFGJNLCuuzD3EKMHBrCTCO9MUKMSbklhZlVqUH19UmpNafIgxGRgCE5mlRJPz
	gaknryTe0NjEzMjSyNzQwsjYnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYNXQn9ci4
	WcqcDVjasf7nv+WTs34Ufpz28klebCaPzo05yzz+X/j2WeFkrOT2tL3PNj2feU9Ba9ejqVs9
	X3cHXNSyOP9kVb1TcOvGDaW1F2WmvDZcvcGAw2J3EMc7qcjLz8wPbgjuOh6XKLd64u8ExRfK
	WdayiosW+9xYnj9r+/5X22/dz7392UyJpTgj0VCLuag4EQCzLQxwMwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 02:06 PM, Viresh Kumar wrote:
> On 10 June 2013 17:43, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> On 06/07/2013 07:23 PM, Viresh Kumar wrote:
>>> On 5 June 2013 13:41, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> 1301500082290 800000 61 11 1 43
>>
>> ...
>>
>> When 1301500082290 ns:
>> cpu0's busy_cpu_threshold : 32 = 64 * (800000/1600000)
> s/64/61 :)

Sorry, my mistake.

>
>>> How are you getting loads different for all your cpus? I believe you
>>> are just recording these values for policy->cpu and all cpus share
>>> same policy on your platform.
>>>
>> I got the Per-CPU load by using cpufreq_notify_transition().
>> when cpufreq governor call dbs_check_cpu().
> I forgot to remove this line in my earlier reply. I understood this towards
> the end of patch.

OK.

>
>>>> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
>>>> +       struct cpufreq_freqs freqs;
>>>> +#endif
>>> Why do you need this to be global?
>> I'll remove global variable and move 'freqs' in some structure.
> ??
>
> You can just make it a local variable in the only function it is used.

You are right. I'll fix it by using local variable.

>
> TIP: Always place a blank line before and after your reply to kernel
> mails, this makes it much more readable.

I will modify this patch according to your comment
and then resend it after merged below patch.
- [PATCH] cpufreq: stats: Remove CONFIG_CPU_FREQ_STAT_DETAILS

Thanks your comment and tip.

Best Regards,
Chanwoo Choi



