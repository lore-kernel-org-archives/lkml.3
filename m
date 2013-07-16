Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab3GPHtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 03:49:50 -0400
Received: from mailhost-o9-p2.internext.fr ([195.5.209.58]:15288 "EHLO
	smtp-delay1.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752705Ab3GPHtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 03:49:49 -0400
Date: Tue, 16 Jul 2013 09:49:25 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Takashi Iwai <tiwai@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Philipp Matthias Hahn <pmhahn@pmhahn.de>, alsa-devel@alsa-project.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [alsa-devel] [BUG] 3.10.[01] modprobe snd-... hangs
Message-ID: <20130716074925.GA9631@brouette>
References: <20130715182010.GA4853@pmhahn.de>
 <87ppujysbk.fsf@rustcorp.com.au>
 <s5h38rfngx3.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h38rfngx3.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Takashi Iwai <tiwai@suse.de> [2013-07-16 08:43]:
> At Tue, 16 Jul 2013 15:11:51 +0930,
> Rusty Russell wrote:

> > Philipp Matthias Hahn <pmhahn@pmhahn.de> writes:
> > > Hello,

> > > My x86_64 systems has some trouble loading some ALSA snd-* modules since
> > > the upgrade to 3.10.[01]: Several automatic modprobe calls hang, but
> > > loading snd-intel-hda and snd-audio-usb by hand still works.

> > Not a known problem to me, at least.  Perhaps it's a dep loop somehow.

> I remember that someone reported it being Debian specific snd-seq-oss
> loading stuff.

There is also additional information here:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=660803

-- 
Damien Wyart
