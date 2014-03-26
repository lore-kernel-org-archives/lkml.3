Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbaCZOkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:40:46 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50073 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753526AbaCZOko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:40:44 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-acpi <linaro-acpi@lists.linaro.org>, Tony <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: RFC: APEI hardware reduced profile
Date: Wed, 26 Mar 2014 15:55:07 +0100
Message-ID: <6220935.TPfvPdvLIs@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5332C32A.5070301@linaro.org>
References: <5332C32A.5070301@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 26, 2014 01:08:10 PM Tomasz Nowicki wrote:
> Hi,

Hi,

This is a question for Tony, Boris and Mauro (CCed now).

> Currently APEI depends on x86 architecture. It is because of many x86 
> specific features like "IA-32 Architecture Corrected Machine Check
> " error source or NMI hardware error notification. However, many other 
> features like "PCI Express Device AER Structure" or GHES via external 
> interrupt can be still used perfectly by other architectures. So my idea 
> is to move x86 dependency away form Kconfig to APEI areas where it 
> really applies to.
> 
> I have started refactoring ghes.c driver in that direction. And here 
> comes my confusion, how should we treat x86 related parts, as fixed 
> profile? (which means we could use ACPI_REDUCED_HARDWARE or 
> CONFIG_ACPI_REDUCED_HARDWARE_ONLY define). I would like to ask for your 
> opinion.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
