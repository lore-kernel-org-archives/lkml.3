Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaAQOVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:21:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50019 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaAQOVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:21:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hanjun Guo <hanjun.guo@linaro.org>
Subject: Re: [PATCH 18/20] clocksource / acpi: Add macro CLOCKSOURCE_ACPI_DECLARE
Date: Fri, 17 Jan 2014 15:21:35 +0100
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
        linaro-acpi@lists.linaro.org, Charles.Garcia-Tobin@arm.com,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <1389961514-13562-19-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1389961514-13562-19-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201401171521.35940.arnd@arndb.de>
X-Provags-ID: V02:K0:Fg+6wyPl53C+NnYy0Uqau6XcVgcyPxdjySGq5W4HHUr
 mqQnKAeW/Xw976PUGLzJGZjbptTBDuFUhWeMRNdBkHiVMqEqCm
 vgXyha5e1kiksh6L13XYMRGfMO5toZ2WLrii91fqvPAiIN+DIw
 LaWfj74h+V2A831eQY+qagwcJZW51cAaLz5HLLwBL9Db3X2cry
 HuVswRxf3oiPUfJa3sgqGX/IRGWJ4zI4/snbdyD2rRg3tEc0WU
 PgJ/VldHU9+VbHtWXbpOhHVTSf7QxAo0hxgv2F8OcfPTeKce56
 cInig342AWI6W0FVTK0bRefHOkmH84L5/QASabTKZYD5K+hbPD
 9qyV54fyZ0flHUq+QMW4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 January 2014, Hanjun Guo wrote:
> 
> From: Amit Daniel Kachhap <amit.daniel@samsung.com>
> 
> This macro does the same job as CLOCKSOURCE_OF_DECLARE. The device
> name from the ACPI timer table is matched with all the registered
> timer controllers and matching initialisation routine is invoked.

I wouldn't anticipate this infrastructure to be required. Shouldn't all
ARMv8 machines have an architected timer?

	Arnd
