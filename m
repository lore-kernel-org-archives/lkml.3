Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbaFRXBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:01:19 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56509 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756058AbaFRXAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:00:10 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Sorin Manolache <sorinm@gmail.com>, Zhang Rui <rui.zhang@intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>
Cc: linux-kernel@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: drivers/acpi/ac.c, re-enabling CONFIG_ACPI_PROCFS_POWER?
Date: Thu, 19 Jun 2014 01:17:45 +0200
Message-ID: <1891948.UFv8RnVsZc@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53A1F65C.9090907@gmail.com>
References: <53A1F65C.9090907@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 18, 2014 10:28:12 PM Sorin Manolache wrote:
> Hello,
> 
> Would it be worth considering re-enabling the old procfs interface for 
> ac.c? There are old tools still around (kpowersave from kde 3.5.10) that 
> expect /proc/acpi/ac_adapter.

Can you please CC ACPI-related messages to linux-acpi@vger.kernel.org?

I'm not sure how much effort that would require at this point.  Rui, Tianyu?

Rafael

