Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaC3BZp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 21:25:45 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:56391 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaC3BZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 21:25:42 -0400
X-AuditID: cbfec37c-b7f536d0000059f2-d3-53377295de65
Message-id: <5337728A.5050609@samsung.com>
Date: Sat, 29 Mar 2014 19:25:30 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.13 00/46] 3.13.8-stable review
References: <20140328173134.630198216@linuxfoundation.org>
In-reply-to: <20140328173134.630198216@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.220]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9hX92pRebBBm+XKlvMWb+GzaJ58Xo2
	i8u75rBZPFl4hsli6qkJLBYLNj5itHjU95bdgd1j56y77B4nZvxm8dg/dw2Q+72B3ePzJrkA
	1igum5TUnMyy1CJ9uwSujNmbzzAVnGSrWDizjamBcQ5rFyMnh4SAicTlvzegbDGJC/fWs3Ux
	cnEICSxjlFix9i+U08sk8fw9SBWIs41R4srucywgLbwCWhJP950Bs1kEVCU+fjvNBmKzCahL
	fH69gx3EFhKQk2haspoZxBYViJB4dXYiVK+gxI/J98BsEYFgibVfFzKCLGAWaGWUePxwKhNI
	Qhjovi2PVkINspI4OLsVbBCngLXEsYUdYHFmIHvlpG2MELa8xOY1b5kh6pUl/lw+xQTxm7LE
	3JZn7BMYRWYh2T0LSfssJO0LGJlXMYqVFicXFCelp1YY6xUn5haX5qXrJefnbmKERFPNDsZ7
	X20OMQpwMCrx8M7QMA8WYk0sK67MPcQowcGsJMK7Tw8oxJuSWFmVWpQfX1Sak1p8iJGJg1Oq
	gXGFXsqP3IO/1u7LtHl1SCCPJ6ctr/pT2/fAnJvpUmvEGb6773yfdGRLttFq/cCdiT5PZ4nx
	6GSszjhsE2FjpMN45NCbte+72ozv9lwOvnb+Ns/Cf311rVfUT3QHsjVeFddODJu/eTN/zM7w
	xYdep2wxV6oo4G0um/5pZfT0Us60Ij1fH7voaCWW4oxEQy3mouJEAKyifIGEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2014 11:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.13.8 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Mar 30 17:31:14 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.8-rc1.gz
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
