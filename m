Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbaIVIqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:46:15 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:38145 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbaIVIqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:46:13 -0400
Date: Mon, 22 Sep 2014 14:16:05 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/5] sound: pci: ctxfi: added reference of snd_card
Message-ID: <20140922084605.GD4870@sudip-PC>
References: <1411315421-24138-1-git-send-email-sudipm.mukherjee@gmail.com>
 <s5h61gg6sq2.wl-tiwai@suse.de>
 <20140922081541.GC4870@sudip-PC>
 <s5hsijk5am8.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hsijk5am8.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 10:21:19AM +0200, Takashi Iwai wrote:
> At Mon, 22 Sep 2014 13:45:41 +0530,
> Sudip Mukherjee wrote:
> > 
> > On Mon, Sep 22, 2014 at 09:04:53AM +0200, Takashi Iwai wrote:
> > > At Sun, 21 Sep 2014 21:33:37 +0530,
> > > Sudip Mukherjee wrote:
> > > > 
> > > > added and initialized a pointer of snd_card in the struct hw to get a reference of
> > > > the card in other functions
> > > 
> > > You need to explain why this change is needed.  The above text shows
> > > what it'd do, but it doesn't give any explanation to convince why this
> > > patch must be merged in.  In this case, it's a preliminary patch for
> > > the changes to convert to dev_*() later.  It's the most important bit,
> > > so don't forget it.
> > >
> > then do i mention in the commit that it is the preliminary patch for the later changes to dev_* ?
> 
> If the purpose of this patch is so, just write what it'll be used
> for.
> 
> > i was thinking that we can get a reference of the card from other functions which are using struct hw
> > is a reason by itself.
> 
> If the purpose of this patch is rather broader, just write what it'll
> be used for.
> 
> Do you see what was missing?
> 
understood.
thanks . I hope v4 will be a better series than this . 

sudip

> 
> Takashi
