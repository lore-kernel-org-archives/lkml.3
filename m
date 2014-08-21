Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaHUO73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:59:29 -0400
Received: from 80-229-23-162.plus.com ([80.229.23.162]:48432 "EHLO
	mail.einon.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaHUO71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:59:27 -0400
Date: Thu, 21 Aug 2014 15:59:23 +0100
From: Mark Einon <mark.einon@gmail.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] staging: et131x: Remove unnecessary i2c_wack variable
Message-ID: <20140821145923.GA23151@msilap.einon.net>
References: <1408573078-9320-1-git-send-email-mark.einon@gmail.com>
 <1408573078-9320-6-git-send-email-mark.einon@gmail.com>
 <CAOMZO5Du34=jpr5B_fHGZ+D_jNR0VSDy2BiO6jj8QByh7V40RQ@mail.gmail.com>
 <20140821091819.GA2230@msilap.einon.net>
 <CAOMZO5DYppH8kURS-eGk9sTD-CfBYt4hWQehKE01Hj=1JXMAdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5DYppH8kURS-eGk9sTD-CfBYt4hWQehKE01Hj=1JXMAdg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 09:06:40AM -0300, Fabio Estevam wrote:
> Hi Mark,
> 
> On Thu, Aug 21, 2014 at 6:18 AM, Mark Einon <mark.einon@gmail.com> wrote:
> 
> >
> > Hi Fabio, thanks for the review.
> >
> > It's a space alignment of parameters to go with the previous change, to
> > keep wrapping consistent in the file:
> >
> > -       while (i2c_wack) {
> > +       while (1) {
> >                 if (pci_write_config_byte(pdev, LBCIF_CONTROL_REGISTER,
> > -                       LBCIF_CONTROL_LBCIF_ENABLE))
> > +                                         LBCIF_CONTROL_LBCIF_ENABLE))
> >
> > So what are you saying - are you just commenting, document it, put it
> > in a seperate patch?
> 
> Yes, it would be better if this part was part of a separate patch.

Ok, I'll remove the indenting changes and sned them in a future patch.
I'll submit a revised v2 of this one.

Cheers,

Mark
