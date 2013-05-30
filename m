Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030385Ab3E3J7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:59:23 -0400
Received: from bitmer.com ([213.157.87.50]:33691 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967560Ab3E3J7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:59:15 -0400
X-Greylist: delayed 1266 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 May 2013 05:59:15 EDT
Date: Thu, 30 May 2013 12:39:14 +0300
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: OMAP: Remove obsolete Makefile line
Message-Id: <20130530123914.fba4840122d4fbca3c182e08@bitmer.com>
In-Reply-To: <1369899460.23034.31.camel@x61.thuisdomein>
References: <1369899460.23034.31.camel@x61.thuisdomein>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.18; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013 09:37:40 +0200
Paul Bolle <pebolle@tiscali.nl> wrote:

> Support for omap2evm was removed in v3.0. But only one of its two
> lines in this Makefile was removed. Remove the second line too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Eyeball tested only.
> 
>  sound/soc/omap/Makefile | 1 -
>  1 file changed, 1 deletion(-)
> 
True, commit 91d94af ("omap: Remove support for omap2evm") removed only omap2evm.o.

Acked-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
