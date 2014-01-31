Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbaAaVcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:32:31 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:60005 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaAaVc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:32:29 -0500
Date: Fri, 31 Jan 2014 16:25:55 -0500
From: Matt Porter <mporter@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Matt Ranostay <mranostay@gmail.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, koen@dominion.thruhere.net,
        pantelis.antoniou@gmail.com
Subject: Re: [PATCH 2/2] iio: Add AS3935 lightning sensor support
Message-ID: <20140131212555.GM31176@beef>
References: <1391076673-5623-1-git-send-email-mranostay@gmail.com>
 <1391076673-5623-2-git-send-email-mranostay@gmail.com>
 <20140131210507.GC3036@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140131210507.GC3036@piout.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 10:05:07PM +0100, Alexandre Belloni wrote:
> Hi Matt,
> 
> On 30/01/2014 at 02:11:13 -0800, Matt Ranostay wrote :
> > AS3935 chipset can detect lightning strikes and reports those
> > back as events and the esimated distance to the storm.
> > 
> > Signed-off-by: Matt Ranostay <mranostay@gmail.com>
> > ---
> >  .../devicetree/bindings/iio/distance/as3935.txt    |  25 ++
> 
> Maybe I'm wrong but wasn't the agreement that the bindings documentation
> has to be sent separately to the devicetree mailing list ?

That's correct. It needs to be separated for ease of review.

-anothermatt

