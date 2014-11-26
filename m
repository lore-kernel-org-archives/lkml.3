Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaKZRP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:15:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47885 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaKZRP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:15:26 -0500
Date: Wed, 26 Nov 2014 18:15:19 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        linux-kernel@vger.kernel.org, Murali Karicheri <m-karicheri2@ti.com>,
        linux-i2c@vger.kernel.org,
        Mike Looijmans <milo-software@users.sourceforge.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/5] i2c: davinci: query STP always when NACK is
 received
Message-ID: <20141126171519.GP4431@pengutronix.de>
References: <1417010393-30598-1-git-send-email-grygorii.strashko@ti.com>
 <1417010393-30598-3-git-send-email-grygorii.strashko@ti.com>
 <20141126155711.GL4431@pengutronix.de>
 <5476005A.6090207@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5476005A.6090207@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Grygorii,

On Wed, Nov 26, 2014 at 06:31:22PM +0200, Grygorii Strashko wrote:
> On 11/26/2014 05:57 PM, Uwe Kleine-König wrote:
> >I don't understand your use of "query" in the subject and later in the
> >commit log. Do you mean "send"?
> 
> will change to "generate". Ok?
yes that would be better understandable

> Can I assume that you are ok with this patch in general?
Yeah, your argument that being able to send a Sr is not sensible made
sense to me. If Wolfram is happy with your patch so am I.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
