Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab3LJASI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:18:08 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:45520 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3LJASG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:18:06 -0500
X-Auth-Info: +LWBT2rR8pTquVuy2wI3Y7qeppVv9k0qvCMkoyy/c5A=
From: Marek Vasut <marex@denx.de>
To: Stefan Agner <stefan@agner.ch>
Subject: Re: [PATCH] ARM: dts: stmpe-ts: fix wrong bindings
Date: Mon, 9 Dec 2013 21:32:29 +0100
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
Cc: viresh.linux@gmail.com, shiraz.hashim@st.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, rob.herring@calxeda.com
References: <1386620111-1413-1-git-send-email-stefan@agner.ch>
In-Reply-To: <1386620111-1413-1-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201312092132.29575.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 09, 2013 at 09:15:11 PM, Stefan Agner wrote:
> Fix bindings for STMPE touchscreen device to match the documented
> bindings and the actual bindings used by the driver.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
> I don't have any of these hardware, but the error is obvious. The device
> probably works anyway since the device/driver will use default values.

Full agreement here.

Reviewed-by: Marek Vasut <marex@denx.de>

btw. I plan to rework the STMPE TS as it doesn't work nicely on my device at 
all. I am seriously lacking time, but I will try! ;-)

Best regards,
Marek Vasut
