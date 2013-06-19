Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934548Ab3FSJMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:12:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:53398 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934347Ab3FSJMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:12:15 -0400
Date: Wed, 19 Jun 2013 11:12:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kevin Strasser <kevin.strasser@linux.intel.com>
cc: linux-kernel@vger.kernel.org, Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Michael Brunner <mibru@gmx.de>, Chris Healy <chealy@imsco-us.com>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Michael Brunner <michael.brunner@kontron.com>
Subject: Re: [PATCH v2 1/4] mfd: Kontron PLD mfd driver
In-Reply-To: <1371589469-32700-2-git-send-email-kevin.strasser@linux.intel.com>
Message-ID: <alpine.DEB.2.02.1306191101290.4013@ionos.tec.linutronix.de>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com> <1371589469-32700-1-git-send-email-kevin.strasser@linux.intel.com> <1371589469-32700-2-git-send-email-kevin.strasser@linux.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013, Kevin Strasser wrote:

This patch set looks reasonable now, except a formal issue.
 
> Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>
> Signed-off-by: Michael Brunner <michael.brunner@kontron.com>

This is wrong, as it says:

 Kevin authored the code, sent it to Michael and Michael sent it to
 LKML.


The original code was authored by Michael. This version was authored
by Kevin based on Michaels code.

So either you keep Michael as the author, then you want 

 From: Michael Brunner <michael.brunner@kontron.com>

 <patch description/>

 Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
 Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>

or you decide that it's a major rewrite by you, then you want:

 This patch is based on the original version authored by
 Michael Brunner <michael.brunner@kontron.com>.

 Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>

 Or 

 Originally-From: Michael Brunner <michael.brunner@kontron.com>.
 Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>

Other than that.

Acked-by: Thomas Gleixner <tglx@linutronix.de>
