Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaCJR2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:28:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbaCJR2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:28:36 -0400
Subject: Re: [PATCH] mfd: Fix cs5535 dependencies
From: Jean Delvare <jdelvare@suse.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
In-Reply-To: <1394466966.5848.48.camel@chaos.site>
References: <20140307220051.0b004abf@endymion.delvare>
	 <20140307212545.6c1dab79@alan.etchedpixels.co.uk>
	 <1394466966.5848.48.camel@chaos.site>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Mon, 10 Mar 2014 18:28:33 +0100
Message-ID: <1394472513.5848.122.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Monday 10 March 2014 à 16:56 +0100, Jean Delvare a écrit :
> Le Friday 07 March 2014 à 21:25 +0000, One Thousand Gnomes a écrit :
> > On Fri, 7 Mar 2014 22:00:51 +0100
> > Jean Delvare <jdelvare@suse.de> wrote:
> > 
> > > As far as I know, the CS5535 and CS5536 chipsets are companions of the
> > > Geode series of processors, which are 32-bit only. So the CS5535
> > > drivers are not needed on x86-64, except for build testing purpose.
> > > 
> > > This aligns the dependencies to what FB_GEODE already uses.
> > > 
> > > Signed-off-by: Jean Delvare <jdelvare@suse.de>
> > 
> > This looks correct to me. Also true for the ATA driver and a few others
> > plus for the CS5510 and 5520.
> 
> And probably CONFIG_GEODE_WDT and CONFIG_SND_CS5535AUDIO as well?

... and CONFIG_PATA_CS5530?

-- 
Jean Delvare
SUSE L3 Support

