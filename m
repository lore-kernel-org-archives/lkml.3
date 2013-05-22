Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab3EVQC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:02:28 -0400
Received: from sauhun.de ([89.238.76.85]:39587 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab3EVQC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:02:27 -0400
Date: Wed, 22 May 2013 18:04:00 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 3/3] sound/soc/fsl: remove leftover release_mem_region
Message-ID: <20130522160357.GA2917@katana>
References: <1369228886-3527-1-git-send-email-wsa@the-dreams.de>
 <1369228886-3527-3-git-send-email-wsa@the-dreams.de>
 <20130522155628.GK1627@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522155628.GK1627@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 10:56:28AM -0500, Mark Brown wrote:
> On Wed, May 22, 2013 at 03:21:26PM +0200, Wolfram Sang wrote:
> > When converting this driver to devm_ioremap_resource, the removal of this now
> > unneeded function has been forgotten.
> 
> This doesn't apply against current code, can you please regenerate
> against topic/fsl or mainline?

? Works fine against v3.10-rc2 here. Or is mainline v3.9 for you?

