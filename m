Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaC3B0q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 21:26:46 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:56399 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaC3B0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 21:26:44 -0400
X-AuditID: cbfec37a-b7fc06d00000555a-a9-533772d3df10
Message-id: <533772D1.6090406@samsung.com>
Date: Sat, 29 Mar 2014 19:26:41 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/22] 3.10.35-stable review
References: <20140328173109.378288825@linuxfoundation.org>
In-reply-to: <20140328173109.378288825@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.220]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9hP93LRebBBvOPaVrMWb+GzaJ58Xo2
	i8u75rBZPFl4hsli6qkJLBYLNj5itHjU95bdgd1j56y77B4nZvxm8dg/dw2Q+72B3ePzJrkA
	1igum5TUnMyy1CJ9uwSujOaGa4wFp9kqbu7pZmtgnMfaxcjJISFgIrGgbxobhC0mceHeeiCb
	i0NIYBmjxMneRcwQTi+TROfbdkYIZxujxP7Nk8FaeAW0JHa0bWAEsVkEVCU+rd/CDGKzCahL
	fH69gx3EFhKQk2hashosLioQIfHq7EQWiF5BiR+T74HZIgLBEmu/LgRbwCzQyijx+OFUJpCE
	sICpxMnJa6AGWUnce38J7G5OAWuJOy9mgNnMQPbKSdsYIWx5ic1r3jJD1CtL/Ll8igniN2WJ
	uS3P2CcwisxCsnsWkvZZSNoXMDKvYhQrLU4uKE5KT60w1CtOzC0uzUvXS87P3cQIiaaqHYx3
	vtocYhTgYFTi4WW0NA8WYk0sK67MPcQowcGsJMK7Tw8oxJuSWFmVWpQfX1Sak1p8iJGJg1Oq
	gXEGj9YTh/nBPF3mFfcszi1nnLMoxHxJeAA/5zTFC0qC7MFlha6Sp8+v9co87/n/pfr0y7Mt
	k/sYuLneb86WNJB3OPhz55k5mg8X1egIMz/0K/ayaDBb8yMo9+u51awirxQsK49O4+MrznI4
	lHBYpaTMwZh9o+yr9LpZe2fucD6cE29xqvNauBJLcUaioRZzUXEiAKk4rI6EAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2014 11:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.35 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Mar 30 17:30:55 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.35-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled, and booted on my test systems. No regressions in dmesg.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
