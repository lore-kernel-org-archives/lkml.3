Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab3I0IRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:17:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41291 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab3I0IRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:17:42 -0400
Date: Fri, 27 Sep 2013 10:17:38 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel@pengutronix.de, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] ARC: Use clockevents_config_and_register over
 clockevents_register_device
Message-ID: <20130927081738.GL16106@pengutronix.de>
References: <1380056737-3471-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <C2D7FE5348E1B147BCA15975FBA2307514E943@IN01WEMBXA.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA2307514E943@IN01WEMBXA.internal.synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 12:01:49PM +0000, Vineet Gupta wrote:
> On 09/25/2013 02:35 AM, Uwe Kleine-König wrote:
> > clockevents_config_and_register is more clever and correct than doing it
> > by hand; so use it.
> >
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> Acked-by: Vineet Gupta <vgupta@synopsys.com>
Thanks for the ack, but I expected that it will be you who takes that
patch. Am I wrong? Who will take it instead?

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
