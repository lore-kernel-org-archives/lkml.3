Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaEHDKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 23:10:49 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:47432 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaEHDKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 23:10:48 -0400
MIME-Version: 1.0
In-Reply-To: <edaf5835a7b14b9a8c053dcd40f2b591@BLUPR05MB037.namprd05.prod.outlook.com>
References: <957b209589094df48ddedbc57c6ccdfd@BLUPR05MB037.namprd05.prod.outlook.com>
 <1399479649-3247-1-git-send-email-boris.brezillon@free-electrons.com> <edaf5835a7b14b9a8c053dcd40f2b591@BLUPR05MB037.namprd05.prod.outlook.com>
From: Mark Roszko <mark.roszko@gmail.com>
Date: Wed, 7 May 2014 23:10:27 -0400
Message-ID: <CAJjB1q+sZvJ=VDFsZJyvqSiOa=zapmnzkAvY1pW2KwjZK4uaKg@mail.gmail.com>
Subject: Re: [PATCH] ARM: at91: fix rtc irq mask for sam9x5 SoCs
To: Bryan Evenson <bevenson@melinkcorp.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atmel actually has this issue in the Errata of the SAM9G25 and SAM9G35
datasheets which might be worth referencing in the description?

>49.7.1 RTC: Interrupt Mask Register cannot be used
>Interrupt Mask Register read always returns 0.
