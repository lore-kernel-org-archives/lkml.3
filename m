Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab3E0Npe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 09:45:34 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:64858 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab3E0Npc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 09:45:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130503214629.741399680@linutronix.de>
References: <alpine.LFD.2.02.1305031514230.2886@ionos> <20130503212258.385818955@linutronix.de>
 <20130503214629.741399680@linutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 27 May 2013 14:45:11 +0100
X-Google-Sender-Auth: bDGECPB0_2HqY_fAsfzOBL0_RN4
Message-ID: <CACxGe6tBxySNPrVCqtyLA5q1QcwnUyzScWsMsT7K-kku+9ZS=Q@mail.gmail.com>
Subject: Re: [RFC patch 6/8] genirq: Split out code in generic chip
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Gerlando Falauto <gerlando.falauto@keymile.com>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 10:50 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Preparatory patch for linear interrupt domains.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

The first 6 are pretty straight forward. On patches 1-6:
Acked-by: Grant Likely <grant.likely@linaro.org>

I'm reading through 7 & 8 now.

g.
