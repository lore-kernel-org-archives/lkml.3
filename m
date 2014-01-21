Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbaAUJtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:49:14 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43613 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754246AbaAUJtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:49:10 -0500
Date: Tue, 21 Jan 2014 09:49:02 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Brown <broonie@kernel.org>, Tushar Behera <tushar.behera@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        jslaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
	device probe
Message-ID: <20140121094902.GR15937@n2100.arm.linux.org.uk>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org> <1390208555-27770-2-git-send-email-tushar.behera@linaro.org> <20140120100530.GY15937@n2100.arm.linux.org.uk> <CAHbNUh3m=uNybv=3yxmr2on=Cc0UuGrYP8zf3GMR-9RQZ394dg@mail.gmail.com> <20140120214305.54f65ffa@www.etchedpixels.co.uk> <20140120231457.GZ17314@sirena.org.uk> <20140120234734.11b78578@www.etchedpixels.co.uk> <20140121001657.GO15937@n2100.arm.linux.org.uk> <20140121090340.6e067d2d@www.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121090340.6e067d2d@www.etchedpixels.co.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 09:03:40AM +0000, Alan Cox wrote:
> On Tue, 21 Jan 2014 00:16:57 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> [I did post a reply to this while on my phone but it got rejected]
> 
> > On Mon, Jan 20, 2014 at 11:47:34PM +0000, Alan Cox wrote:
> > > But yes I agree about the idiom, but a definite NAK to any attempts to
> > > plaster over this grand screwup by crapping in the tty core. Your turd,
> > > deal with it locally in the ARM code if you can't apply common sense and
> > > just go dynamic.
> > 
> > I believe at the time there was no one maintaining the device list to
> > _do_ that allocation - AMBA PL011 came along in 2005 after (I believe)
> > hpa stopped looking after that list.
> 
> git log Documentation/devices.txt

Hmm.  Given that git history starts at 2.6.12-rc2, and this was introduced
in 2.5 kernels, there's no point me looking, because I know the history
I have access to does not go back to that time.

And I know for certain that the devices list *did* fall out of maintainership
for a while.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
