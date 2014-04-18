Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaDRRQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:16:43 -0400
Received: from nbd.name ([46.4.11.11]:39490 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbaDRRQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:16:40 -0400
Message-ID: <53515DF2.8060106@phrozen.org>
Date: Fri, 18 Apr 2014 19:16:34 +0200
From: John Crispin <john@phrozen.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Leif Lindholm <leif.lindholm@linaro.org>, linux-kernel@vger.kernel.org
CC: patches@linaro.org, linux-mips@linux-mips.org, devicetree@vger.kernel.org,
        John Crispin <blogic@openwrt.org>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 2/3] mips: dts: add device_type="memory" where missing
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org> <1397756521-29387-3-git-send-email-leif.lindholm@linaro.org>
In-Reply-To: <1397756521-29387-3-git-send-email-leif.lindholm@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 17/04/2014 19:42, Leif Lindholm wrote:
> A few platforms lack a 'device_type = "memory"' for their memory 
> nodes, relying on an old ppc quirk in order to discover its
> memory. Add this, to permit that quirk to be made ppc only.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org> Cc:
> linux-mips@linux-mips.org Cc: devicetree@vger.kernel.org Cc: John
> Crispin <blogic@openwrt.org> Cc: Mark Rutland
> <mark.rutland@arm.com>

Acked-by: John Crispin <blogic@openwrt.org?


Thanks for the cleanup ....


> --- arch/mips/lantiq/dts/easy50712.dts    |    1 + 
> arch/mips/ralink/dts/mt7620a_eval.dts |    1 + 
> arch/mips/ralink/dts/rt2880_eval.dts  |    1 + 
> arch/mips/ralink/dts/rt3052_eval.dts  |    1 + 
> arch/mips/ralink/dts/rt3883_eval.dts  |    1 + 5 files changed, 5
> insertions(+)
> 
> diff --git a/arch/mips/lantiq/dts/easy50712.dts
> b/arch/mips/lantiq/dts/easy50712.dts index fac1f5b..143b8a3 100644 
> --- a/arch/mips/lantiq/dts/easy50712.dts +++
> b/arch/mips/lantiq/dts/easy50712.dts @@ -8,6 +8,7 @@ };
> 
> memory@0 { +		device_type = "memory"; reg = <0x0 0x2000000>; };
> 
> diff --git a/arch/mips/ralink/dts/mt7620a_eval.dts
> b/arch/mips/ralink/dts/mt7620a_eval.dts index 35eb874..709f581
> 100644 --- a/arch/mips/ralink/dts/mt7620a_eval.dts +++
> b/arch/mips/ralink/dts/mt7620a_eval.dts @@ -7,6 +7,7 @@ model =
> "Ralink MT7620A evaluation board";
> 
> memory@0 { +		device_type = "memory"; reg = <0x0 0x2000000>; };
> 
> diff --git a/arch/mips/ralink/dts/rt2880_eval.dts
> b/arch/mips/ralink/dts/rt2880_eval.dts index 322d700..0a685db
> 100644 --- a/arch/mips/ralink/dts/rt2880_eval.dts +++
> b/arch/mips/ralink/dts/rt2880_eval.dts @@ -7,6 +7,7 @@ model =
> "Ralink RT2880 evaluation board";
> 
> memory@0 { +		device_type = "memory"; reg = <0x8000000 0x2000000>; 
> };
> 
> diff --git a/arch/mips/ralink/dts/rt3052_eval.dts
> b/arch/mips/ralink/dts/rt3052_eval.dts index 0ac73ea..ec9e9a0
> 100644 --- a/arch/mips/ralink/dts/rt3052_eval.dts +++
> b/arch/mips/ralink/dts/rt3052_eval.dts @@ -7,6 +7,7 @@ model =
> "Ralink RT3052 evaluation board";
> 
> memory@0 { +		device_type = "memory"; reg = <0x0 0x2000000>; };
> 
> diff --git a/arch/mips/ralink/dts/rt3883_eval.dts
> b/arch/mips/ralink/dts/rt3883_eval.dts index 2fa6b33..e8df21a
> 100644 --- a/arch/mips/ralink/dts/rt3883_eval.dts +++
> b/arch/mips/ralink/dts/rt3883_eval.dts @@ -7,6 +7,7 @@ model =
> "Ralink RT3883 evaluation board";
> 
> memory@0 { +		device_type = "memory"; reg = <0x0 0x2000000>; };
> 
> 
