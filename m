Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab3IQKns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 06:43:48 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:41816 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab3IQKnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:43:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAPUj1OMjwnFS01R0DQxss0j6svUD4Rdx-B5B1ONdPR=C_520yQ@mail.gmail.com>
References: <CAPUj1OMjwnFS01R0DQxss0j6svUD4Rdx-B5B1ONdPR=C_520yQ@mail.gmail.com>
Date: Tue, 17 Sep 2013 16:13:46 +0530
Message-ID: <CAPUj1ON2cdOD4aSo0E2xwDyz8W6Mbyjpw-z59Po9YiWbF+rVTA@mail.gmail.com>
Subject: Re: [V3,3/7] ARM: dts: Add gpio-button entries for Arndale board
From: MJ embd <mj.embd@gmail.com>
To: linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Tushar Behera <tushar.behera@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PS:Adding linux kernel for a larger forum comments

Hi Linaro,

I am trying to attach interrupt handlers to the push buttons on the
arndale board.
Your patch adds in dts information on the push buttons

menu {
+                       label = "SW-TACT2";
+                       gpios = <&gpx1 4 1>;
+                       linux,code = <139>;
+                       gpio-key,wakeup;
+               };

I assume that <139> is the GPU number in base 10. Is this correct ?
Also what is the significance of gpx1 and 4 1 ?

As per my understanding if 139 the GPIO number then it should be
mapped to a GPIO register where the state Input/ouput/Interrupt has to
be set.

I am not able to find that register in the
"Exynos_5_Dual_User_Manaul_Public_REV100-0", All I could find a set of
GPXXXX registers but no mapping between <139> and those registers.

Can anyone explain the steps, on how to associate the push button to INT (IRQ)

Thanks in Advance..
