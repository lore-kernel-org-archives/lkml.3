Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbaJAIOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:14:43 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:50041 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaJAIOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:14:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 14/15] misc: at25: Make use of device property API
Date: Wed, 01 Oct 2014 10:14:31 +0200
Message-ID: <2142007.2bj4iEgvpB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2074642.sV7QBxD3Ne@vostro.rjw.lan>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <1852462.V1jlbi8OPt@vostro.rjw.lan> <2074642.sV7QBxD3Ne@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:44ag1hKN6+JwxZ4mf+JyI5yyziUPi5olx8rDYB97Vhq
 2e/7w9ocrt1Wec89ZC9PyT0yzEAMFKHGcKCCmXBodpF8lQKNSQ
 5Ps1GjQoUifnUQZM0rZ/OlVgU4lbgukMgW6evK5LVClrqcmDrL
 FI2VSgTVhPnRz8jS6dJqBc5xYXQzVD/HtstUH2VhJ4dJ8RsEp/
 watEjNs1XZjtZgkMwWlSKSWjJ3+ojhMe3K1GuESQjPwfScFP0v
 ROtI4NEiJslw+bwcyopjfdsxOArXbzAhVbx3Q5ggNnqk7smqEY
 59N3AcvjT9bztDlnAafd5ztXaR4siKsAuiQBWESxmBKxh0fNM/
 uWA7z7wyI4RT6LcMpoaE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 04:21:18 Rafael J. Wysocki wrote:
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Make use of device property API in this driver so that both DT and ACPI
> based systems can use this driver.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 

Looks good,

Acked-by: Arnd Bergmann <arnd@arndb.de>
