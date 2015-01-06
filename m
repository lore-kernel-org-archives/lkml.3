Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbbAFThh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:37:37 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:54097 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbbAFThI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:37:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] mfd: syscon: fix syscon probing from dt
Date: Tue, 06 Jan 2015 20:36:33 +0100
Message-ID: <35536202.10QfWIDQqq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420558236-14063-1-git-send-email-p.zabel@pengutronix.de>
References: <1420558236-14063-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:NRGc18yvTLdAa8vCET2yaFyWJj3WQ82fsEdf/sLNiJHciwFCIIw
 RYJE6zweI3PtVP/OzU3yz5fURcsClgX5FXzU6aSlbmPYmk7/luXsstgUGFmMBvlbyJUTb3b
 K34lWj3Q2AI2VCpMSUEWPRMV0Fxjy0z3tsbRbf1MThYj/TbKE3YUu9EjZ8UL+M3o02AdiZZ
 M7hh0JVpGgxFNC5QYSjHg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2015 16:30:36 Philipp Zabel wrote:
> Patch bdb0066df96e ("mfd: syscon: Decouple syscon interface from platform devices")
> breaks probing pure syscon devices from device tree, such as anatop and
> iomuxc-gpr on i.MX. This patch adds back the dt id table to match against
> "syscon" compatible device tree nodes.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> 

I don't understand it. Why is this required?

	Arnd
