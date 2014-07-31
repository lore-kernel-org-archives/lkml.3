Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbaGaK1D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:27:03 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:52421 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbaGaK1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:27:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Robert Richter <rric@kernel.org>
Subject: Re: [PATCH 2/5] arm64, thunder: Add initial dts for Cavium Thunder SoC
Date: Thu, 31 Jul 2014 12:24:13 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Robert Richter <rrichter@cavium.com>, devicetree@vger.kernel.org
References: <1406732794-20920-1-git-send-email-rric@kernel.org> <1406732794-20920-3-git-send-email-rric@kernel.org>
In-Reply-To: <1406732794-20920-3-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201407311224.14097.arnd@arndb.de>
X-Provags-ID: V02:K0:Vuyjv4qyJuRIQFz1U9PkbP+3G4/nILu4lQrGNavpxNi
 AXhNd3ol2fJVdtdb5SeKxGUkHfJyEkY8YajeKKnHXQbO8NjjBn
 CVBN77KU4TnpNMuN/gcygy+ksNGT5D9//sUzVBB2ykty1ZxiwA
 1AoYMK2ChzQ09gdjxDDis41sMsNl2jLgdN6nxt2++vcxpsaZK1
 XUufLr5opl2nt+UQciF5On85eEYa/gcGdnrFJDrUheayV+TnNv
 rObG5kHZPnfOG07vsdvgbn4PRb8S9B58suZ0hQxmhfuFnI8g9w
 ZoqLPRgz3e6cJAiPKKRjCl4+AgCpdGhSh/S8prkn+J2S6LXORr
 uxBy3kDp2lB30M7uMrQln2Ls6Z5Yh7aPUfisdEO81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2014, Robert Richter wrote:
> +/*
> + * Cavium Thunder DTS file
> + *
> + * Copyright (C) 2013, Cavium Inc.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + */

I think it makes sense to use a permissive license for these files here,
since board vendors may want to include a copy of the binary in their
firmware, which isn't necessarily GPL compatible.

What is Cavium's interest in making this GPL?

	Arnd
