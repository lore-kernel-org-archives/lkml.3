Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab3H2J0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:26:14 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:42746 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209Ab3H2J0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:26:13 -0400
Date: Thu, 29 Aug 2013 11:27:01 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 0/2] ARM: Dove: Add audio to the DT
Message-ID: <20130829112701.3bd32fa0@armhf>
In-Reply-To: <20130828164829.14256ce2@skate>
References: <20130828113438.0a77fd54@armhf>
	<20130828164829.14256ce2@skate>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013 16:48:29 +0200
Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:

> On Wed, 28 Aug 2013 11:34:38 +0200, Jean-Francois Moine wrote:
> > This patch series adds audio DT to the Dove boards and activates the
> > Cubox audio device.
> > 
> > Full audio in the Cubox will work when the DT extension of the generic
> > simple audio card will be complete.  
> 
> What is the status of this generic simple audio card effort? I've seen
> the patch you had posted at https://lkml.org/lkml/2013/7/20/128 and the
> following discussion. Has anyone picked up the work of Kuninori
> Morimoto?

Hi Thomas,

I don't feel able yet to enter the ALSA internals.
Otherwise, there is this message from Lars:

http://mailman.alsa-project.org/pipermail/alsa-devel/2013-August/064951.html

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
