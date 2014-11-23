Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaKWUgi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 15:36:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60114 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaKWUgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 15:36:36 -0500
Date: Sun, 23 Nov 2014 21:36:34 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [4/5] i2c: davinci: use bus recovery infrastructure
Message-ID: <20141123203634.GG4431@pengutronix.de>
References: <1416477788-5544-5-git-send-email-grygorii.strashko@ti.com>
 <20141121190744.GB4431@pengutronix.de>
 <546F9382.40102@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <546F9382.40102@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Grygorii,

On Fri, Nov 21, 2014 at 09:33:22PM +0200, Grygorii Strashko wrote:
> On 11/21/2014 09:07 PM, Uwe Kleine-König wrote:
> > On Thu, Nov 20, 2014 at 12:03:07PM +0200, Grygorii Strashko wrote:
> > Just another general comment about the driver that doesn't influence the
> > correctness of this patch: The i2c-davinci driver is quite quick to
> > reset the bus. I wonder how often this reset triggers. Is the bus in
> > question less "stable" than others?
> 
> In comparison to ..? :)
In comparison to other bus drivers in other SoCs. I know this might be
hard to answer. I just wonder where the reason for this has to be
located. Strange hardware? Software bug? Or is this SoC just operating
with strange slaves more often than others?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
