Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbaG2XCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:02:36 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:41186 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbaG2XCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:02:34 -0400
Message-ID: <53D82803.9060804@samsung.com>
Date: Wed, 30 Jul 2014 08:02:27 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: kgene.kim@samsung.com, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        linux-doc@vger.kernel.org, t.figa@samsung.com,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        ben-linux@fluff.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] ARM: dts: Add TMU dt node and missing data for Exynos3250
References: <1406600232-31033-1-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1406600232-31033-1-git-send-email-cw00.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/14 11:17, Chanwoo Choi wrote:
> This patchset add TMU (Thermal Management Unit) dt node and missing pinctrl
> property of uart0/1. Also, this patchset remove duplcate 'interrupt-parent'
> property for code clean.
>
> Chanwoo Choi (3):
>    ARM: dts: Add TMU dt node to monitor the temperature for Exynos3250
>    ARM: dts: Remove duplicate 'interrput-parent' property for Exynos3250
>    ARM: dts: Add missing pinctrl for uart0/1 for Exynos3250
>
>   arch/arm/boot/dts/exynos3250.dtsi | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
>
Applied this whole series, thanks.

- Kukjin
