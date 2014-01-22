Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbaAVL61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:58:27 -0500
Received: from trinity.fluff.org ([89.16.178.74]:53021 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161AbaAVL60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:58:26 -0500
X-Greylist: delayed 1028 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jan 2014 06:58:26 EST
Date: Wed, 22 Jan 2014 11:40:58 +0000
From: Ben Dooks <ben@trinity.fluff.org>
To: Dimitris Papastamos <Dimitris.Papastamos@Wolfsonmicro.com>
Cc: Mark Brown <broonie@kernel.org>, Daniel Matuschek <daniel@matuschek.net>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: wm8804: Allow control of master
 clock divider in PLL generation
Message-ID: <20140122114058.GB16359@trinity.fluff.org>
References: <alpine.DEB.2.02.1401142030110.23472@parallels-Parallels-Virtual-Platform>
 <20140117005437.GQ17314@sirena.org.uk>
 <634C081ADD030F4A829AD09D85144F253611607A04@EXCMB2.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <634C081ADD030F4A829AD09D85144F253611607A04@EXCMB2.wolfsonmicro.main>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 10:35:10AM +0000, Dimitris Papastamos wrote:
> > Charles (or someone else from Wolfson), you commented on previous
> > versions of this - are you still OK with it?
> 
> Looks good to me.
> 
> Privacy & Confidentiality Notice
> -------------------------------------------------
> This message and any attachments contain privileged and confidential information that is intended solely for the person(s) to whom it is addressed. If you are not an intended recipient you must not: read; copy; distribute; discuss; take any action in or make any reliance upon the contents of this message; nor open or read any attachment. If you have received this message in error, please notify us as soon as possible on the following telephone number and destroy this message including any attachments. Thank you.

Shouldn't be posting them to public lists then.

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

