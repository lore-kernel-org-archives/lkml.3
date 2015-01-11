Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbbAKUSQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 15:18:16 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:53878 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbbAKUSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 15:18:15 -0500
X-Originating-IP: 50.43.58.154
Date: Sun, 11 Jan 2015 12:18:06 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jaroslav Kysela <perex@perex.cz>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rashika Kheria <rashika.kheria@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: lx6464es: lx_core: Remove some unused functions
Message-ID: <20150111201806.GA1074@thin>
References: <1420990982-20187-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <s5htwzx2txw.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5htwzx2txw.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 04:55:23PM +0100, Takashi Iwai wrote:
> At Sun, 11 Jan 2015 16:43:02 +0100,
> Rickard Strandqvist wrote:
> > 
> > Removes some functions that are not used anywhere:
> > lx_buffer_cancel() lx_buffer_free() lx_stream_sample_position()
> > lx_stream_state() lx_pipe_sample_count()
> 
> We really shouldn't delete the code but keep somehow disabled for such
> a driver that has no hardware spec documents available.  Since the
> source code is the only reference, the implemented code is the only
> information if we need to change / fix anything.

Easy enough to get it back out of version control if so.

- Josh Triplett
