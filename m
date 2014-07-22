Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbaGVKCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:02:49 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:33633 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753318AbaGVKCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:02:46 -0400
Message-ID: <1406023366.25343.44.camel@hornet>
Subject: Re: [PATCH v9] video: ARM CLCD: Add DT support
From: Pawel Moll <pawel.moll@arm.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 22 Jul 2014 11:02:46 +0100
In-Reply-To: <1404824767.21897.7.camel@hornet>
References: <1403610911-31491-1-git-send-email-pawel.moll@arm.com>
	 <1404824767.21897.7.camel@hornet>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-08 at 14:06 +0100, Pawel Moll wrote:
> On Tue, 2014-06-24 at 12:55 +0100, Pawel Moll wrote:
> > This patch adds basic DT bindings for the PL11x CLCD cells
> > and make their fbdev driver use them.
> > 
> > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> 
> As two weeks passed without any further comment, I'm assuming that there
> are no more obstacles for this patch to be merged.
> 
> Tomi, will you pick it up for 3.17, as you offered? Russell, if you
> prefer to take it via your tree, it's in your system as 8005/4.

Ping...

Tomi?

Paweł

