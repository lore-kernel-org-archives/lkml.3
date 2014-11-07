Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaKGOOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:14:47 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:62964 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaKGOOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:14:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-acpi@lists.linaro.org
Cc: Tomasz Nowicki <tomasz.nowicki@linaro.org>, catalin.marinas@arm.com,
        will.deacon@arm.com, bhelgaas@google.com, Liviu.Dudau@arm.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rjw@rjwysocki.net,
        linux-pci@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-acpi] [RFC PATCH 3/4] arm64, acpi, pci: Add arch specific functions for mmconfig driver.
Date: Fri, 07 Nov 2014 15:12:45 +0100
Message-ID: <16660879.6KxQndPqBW@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415366876-30811-4-git-send-email-tomasz.nowicki@linaro.org>
References: <1415366876-30811-1-git-send-email-tomasz.nowicki@linaro.org> <1415366876-30811-4-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:on6N9WnydhixsC3TF5T2ZQSs/Lia/2NW+kUooAkxDBE
 y1UBX4/GkTAs/O63WZVpOU+ap00rt0tkOE8EP7flJe2957Z/nF
 nILTZbp3hrKRuEbfDFXtpQ6AuoI2VUsUGOfbzG64zzbuYww+cy
 qXMvSXVTXWidSJ3vKOKqDN3BNilI/EqD+6X91wiOgANjtvBhlh
 TQTiuJ6J1lGGovO2EdWAHBETLeUcPotXS9vVwhwySk6OesKkhG
 aQoT/WVhUFfK3vNGOXiUGG6CuXlkO1v0GXyLkW365hD4hT6kU6
 YLHLaMgRplZkEut1vdQebHAzFuDHQJmbhVhH+pyZKMFK3Fktby
 yG2F675fwRL6jlt9o6jA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 November 2014 14:27:55 Tomasz Nowicki wrote:
> These calls allow to map/unmap PCI config space ranges (which are specified in
> MMCFG ACPI table).
> 
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> 

Nothing in this patch looks arm64 specific, and most of it looks like a
copy of the x86 code.

	Arnd
