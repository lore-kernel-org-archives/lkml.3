Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbaGWHIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:08:37 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38540 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756134AbaGWHIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:08:35 -0400
Date: Wed, 23 Jul 2014 09:08:31 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Bin Liu <binmlist@gmail.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        balbi@ti.com, gregkh@linuxfoundation.org, Peter.Chen@freescale.com,
        kishon@ti.com, stern@rowland.harvard.edu,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] usb: move the OTG state from the USB PHY to the OTG
 structure
Message-ID: <20140723070831.GA10816@kwain>
References: <1404901036-27682-1-git-send-email-antoine.tenart@free-electrons.com>
 <1404901036-27682-2-git-send-email-antoine.tenart@free-electrons.com>
 <CADYTM3ZijsqSUTvBEscJCP94aWCPahPJ1se+g0+ssqwcE_yAxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADYTM3ZijsqSUTvBEscJCP94aWCPahPJ1se+g0+ssqwcE_yAxg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 22, 2014 at 04:33:54PM -0500, Bin Liu wrote:
> On Wed, Jul 9, 2014 at 5:17 AM, Antoine Ténart
> <antoine.tenart@free-electrons.com> wrote:
> > diff --git a/drivers/usb/chipidea/debug.c b/drivers/usb/chipidea/debug.c
> > index 7cccab6ff308..9a9702773e43 100644
> > --- a/drivers/usb/chipidea/debug.c
> > +++ b/drivers/usb/chipidea/debug.c
> > @@ -219,8 +219,7 @@ int ci_otg_show(struct seq_file *s, void *unused)
> >         fsm = &ci->fsm;
> >
> >         /* ------ State ----- */
> > -       seq_printf(s, "OTG state: %s\n\n",
> 
> Is this line removed by accident?
> 
> > -               usb_otg_state_string(ci->transceiver->state));
> > +               usb_otg_state_string(ci->transceiver->otg.state));
> >
> >         /* ------ State Machine Variables ----- */

It is. I'll fix this.

Thanks!

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
