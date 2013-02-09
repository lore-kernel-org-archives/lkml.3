Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760674Ab3BIONh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 09:13:37 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:46602 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3BIONf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 09:13:35 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] mfd: support stmpe1801 18 bits enhanced port expander
To: Linus Walleij <linus.walleij@linaro.org>,
        Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <samuel.ortiz@intel.com>,
        Lee Jones <lee.jones@linaro.org>
In-Reply-To: <CACRpkdZaJWji+hjP=CC4T2zuUnpccKE0q=hSHECSkEHoQPQVjw@mail.gmail.com>
References: <1355993839-12479-1-git-send-email-jean-nicolas.graux@stericsson.com> <CACRpkdZaJWji+hjP=CC4T2zuUnpccKE0q=hSHECSkEHoQPQVjw@mail.gmail.com>
Date: Sat, 09 Feb 2013 14:13:30 +0000
Message-Id: <20130209141330.D99523E30EC@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2012 10:23:28 +0100, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Dec 20, 2012 at 9:57 AM, Jean-Nicolas Graux
> <jean-nicolas.graux@stericsson.com> wrote:
> 
> > Provides support for 1801 variant of stmpe gpio port expanders.
> > This chip has 18 gpios configurable as GPI, GPO, keypad matrix,
> > special key or dedicated key function.
> >
> > Note that special/dedicated key function is not supported yet.
> >
> > Signed-off-by: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

I assume you'll merge this via the mfd tree.

