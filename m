Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaAQOPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:15:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62383 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaAQOPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:15:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hanjun Guo <hanjun.guo@linaro.org>
Subject: Re: [PATCH 12/20] ARM64 / ACPI: Use Parked Address in GIC structure for spin table SMP initialisation
Date: Fri, 17 Jan 2014 15:15:20 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org, Charles.Garcia-Tobin@arm.com
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <1389961514-13562-13-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1389961514-13562-13-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201401171515.21250.arnd@arndb.de>
X-Provags-ID: V02:K0:4BFOy8dP6J6YS0b0yKdDU985pXZoEyDkOdwbl55rt1y
 j/z6uoPz9hYRa62Wiod9+2VjDlfWphzGleYdTnNFBKiNYR9cIF
 dNkv23loQ+pFGyDbKp/EOhn53A6tnuOjnPkUlLu5Q0y3LaEaDT
 BPwwgJCTun/Kc49ZzTQ6/Xuzsle2LRbZEceQhBGjRUMGozWx0y
 Qh+TxngP7iaXZy22KV7lo21Ns+2Et/gjd0HoeTYAEcpOTK2Mqm
 zettudAB8aMo6qQaJZ2DWYDuvg+EaOyWIxO2CJihnwm91gkhLD
 /C1P3wcWDOkELOxmPf1eppGfueF/ACswZeBnFZ+UvzCYfrk7xV
 pChqaa2gjDJtciC7ID5g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 January 2014, Hanjun Guo wrote:
> +/* Parked Address in ACPI GIC structure */
> +static u64 parked_address[NR_CPUS];

Please use the per_cpu infrastructure rather than NR_CPUS long arrays.

	Arnd
