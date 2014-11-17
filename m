Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaKQQAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 11:00:43 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:50873 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaKQQAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 11:00:41 -0500
Date: Mon, 17 Nov 2014 17:00:38 +0100
From: Johan Hovold <johan@kernel.org>
To: Bruno Thomsen <bth@kamstrup.dk>
Cc: Johan Hovold <johan@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "bruno.thomsen@gmail.com" <bruno.thomsen@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: phy/micrel: KSZ8031RNL RMII clock reconfiguration bug
Message-ID: <20141117160038.GB14630@localhost>
References: <1412866094-4972-1-git-send-email-bth@kamstrup.dk>
 <20141111194101.GI29789@localhost>
 <915054555B5659448ACF8A70E114824D01704B9131@Exchange2010.kamstrup.dk>
 <20141115141804.GA24633@localhost>
 <915054555B5659448ACF8A70E114824D01704BD71E@Exchange2010.kamstrup.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <915054555B5659448ACF8A70E114824D01704BD71E@Exchange2010.kamstrup.dk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 02:56:45PM +0000, Bruno Thomsen wrote:
> > Did you specify a led-mode as well, or was the Operation Mode Strap
> > Override (OMSO) write the first access after the soft reset?
>
> No led-mode was specified so OMSO was the first write.

Did you try setting a led-mode before changing the clock mode? Perhaps
that could also trigger the problem (i.e. when the clock-mode change
isn't the first write after reset).

> > Would you able to test my series on your setup, and possibly a
> > couple of diagnostic patches on top?
>
> Sure, I can try later this week.

Much appreciated. I'll resend the last part of the series (which is not
already in linux-next) and make sure to put you on CC.

Thanks,
Johan
