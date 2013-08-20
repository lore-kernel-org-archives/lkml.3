Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab3HTIhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:37:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:26438 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab3HTIhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:37:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,918,1367996400"; 
   d="scan'208";a="365372826"
Date: Tue, 20 Aug 2013 10:36:52 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] mfd: mc13xxx: make it possible to use the codec without
 pdata
Message-ID: <20130820083652.GA17521@zurbaran>
References: <1376396148-29801-1-git-send-email-m.grzeschik@pengutronix.de>
 <20130820082636.GH23699@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820082636.GH23699@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Tue, Aug 20, 2013 at 09:26:36AM +0100, Lee Jones wrote:
> On Tue, 13 Aug 2013, Michael Grzeschik wrote:
> 
> > In case of devicetree, we currently don't have a way to append pdata for
> > the codec. This patch makes it possible to probe the codec without pdata
> > for that case.
> > 
> > Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > ---
> >  drivers/mfd/mc13xxx-core.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> This patch doesn't apply. What tree is it based on?
Please wait a bit before applying this one. I'd like to get Dmitry's
feedback on the input one first.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
