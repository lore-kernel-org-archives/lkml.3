Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbaC0Kz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 06:55:56 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16641 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbaC0Kzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 06:55:54 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-1c-533403b7d816
Message-id: <533403B3.6070602@samsung.com>
Date: Thu, 27 Mar 2014 11:55:47 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org
Cc: devicetree@vger.kernel.org, linux@arm.linux.org.uk, t.figa@samsung.com,
        linux-kernel@vger.kernel.org, b.brezillon@overkiz.com,
        khilman@linaro.org, festevam@gmail.com, shawn.guo@linaro.org,
        kernel@pengutronix.de, nicolas.ferre@atmel.com, plagnioj@jcrosoft.com
Subject: Re: [PATCH] clk: register fixed-clock only if #clock-cells property is
 present
References: <1395858127-18730-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1395858127-18730-1-git-send-email-s.nawrocki@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t/xy7rbmU2CDc6/F7a4cO4wo8X8I+dY
	LR5e9bdYNXUni8XXwysYLTY9vsZqcXnXHDaL25d5LZ5OuMhm8e1yM7vFuocvmCyerlvCbLF+
	xmsWB16PluYeNo8Fv7ayeOycdZfd49WFOywed67tYfPYvKTeY9LiP2we/X8NPPq2rGL0+LxJ
	LoArissmJTUnsyy1SN8ugSujadt09oK9zBVPOj+xNTC+Zepi5OSQEDCR+L3+FTOELSZx4d56
	ti5GLg4hgaWMEpffz2EBSQgJfGKUeHgyvYuRg4NXQEtifm8kSJhFQFXi35s2NhCbTcBQovdo
	HyOILSoQITF34mawOK+AoMSPyffAxogI2Ev8mPCSBWQ+s0APk8TBX9/AEsICkRIHF+xkAZkv
	JOAm0XuoBiTMKeAucePoFrA7mQV0JPa3TmODsOUlNq95yzyBUWAWkhWzkJTNQlK2gJF5FaNo
	amlyQXFSeq6hXnFibnFpXrpecn7uJkZIJH3Zwbj4mNUhRgEORiUe3h33jYKFWBPLiitzDzFK
	cDArifD2/zUOFuJNSaysSi3Kjy8qzUktPsTIxMEp1cBYuO3vPa+rbqbB7/ujZDq3Bv/3rp/N
	v1X2cvRENibPROkS46kZbVMnBXOlzK63Tftz9OHZ45/sHkqcLdnUebrmT6Fhqsi0Tfxv/Lk9
	cieW/L47ecd27bQGDS+ZW3xSD7wN4vKvr12ZH5Jf/uqXzIQ2+9uXp+14L3Mh45STxzn2jfdl
	l5dNiPinxFKckWioxVxUnAgAWFwV0oICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike, please ignore this patch for now. It turns out a less intrusive
change [1] is enough to fix the regressions on both imx and exynos.

I'm going to address the issue properly for next kernel release and
make exynos use regular fixed-clock driver, rather than registering
the external clock generators within the SoC main clock controller
driver.

-- 
Thanks,
Sylwester

[1] http://permalink.gmane.org/gmane.linux.kernel/1673639
