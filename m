Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab3HCLqg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 07:46:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40031 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab3HCLqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 07:46:35 -0400
Date: Sat, 3 Aug 2013 12:46:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 2/4] ASoc: kirkwood: merge kirkwood-i2c and
	kirkwood-dma
Message-ID: <20130803114621.GA19632@n2100.arm.linux.org.uk>
References: <20130731081806.244752d4@armhf> <20130803114321.GW23006@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130803114321.GW23006@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 03, 2013 at 12:43:21PM +0100, Russell King - ARM Linux wrote:
> On Wed, Jul 31, 2013 at 08:18:06AM +0200, Jean-Francois Moine wrote:
> > To avoid the declaration of a 'kirkwood-pcm-audio' device in the DT,
> > this patch merges the kirkwood-i2c and kirkwood-dma drivers into one
> > module associated with 'kirkwood-i2s'. 
> 
> This is broken unless you use my patch.  You can't just stick the
> two drivers together because they both make use of the platform
> device's driver data field for two incompatible uses.  I've already
> explained that, and I've even sent you a patch to fix that, but you
> seem to ignore anything that you didn't write.
> 
> So... I'm going to work on this issue this weekend and merge the two
> drivers myself, and send Mark my own patches to do this.

Sorry, I take that back, your cover email does say that this depends on
my patch.  I'll give your patches a go this weekend instead then.  Thanks.
