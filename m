Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbaIPNmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:42:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46306 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753817AbaIPNmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:42:10 -0400
Date: Tue, 16 Sep 2014 15:41:56 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Peter Chen <peter.chen@freescale.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>, balbi@ti.com,
        gregkh@linuxfoundation.org, kishon@ti.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, yoshihiro.shimoda.uh@renesas.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 9/9] usb: chipidea: add support to the generic PHY
 framework in ChipIdea
Message-ID: <20140916134156.GB4869@kwain>
References: <1410777309-12552-1-git-send-email-antoine.tenart@free-electrons.com>
 <1410777309-12552-10-git-send-email-antoine.tenart@free-electrons.com>
 <20140916000720.GB3379@peterchendt>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140916000720.GB3379@peterchendt>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 08:07:21AM +0800, Peter Chen wrote:
> On Mon, Sep 15, 2014 at 12:35:09PM +0200, Antoine Tenart wrote:
> > diff --git a/drivers/usb/chipidea/debug.c b/drivers/usb/chipidea/debug.c
> > index 8f437e1512fa..999e9d683d7a 100644
> > --- a/drivers/usb/chipidea/debug.c
> > +++ b/drivers/usb/chipidea/debug.c
> > @@ -220,7 +220,7 @@ static int ci_otg_show(struct seq_file *s, void *unused)
> >  
> >  	/* ------ State ----- */
> >  	seq_printf(s, "OTG state: %s\n\n",
> > -		usb_otg_state_string(ci->usb_phy->otg.state));
> > +		   usb_otg_state_string(ci->otg.state));
> 
> This one should be at your 8th patch, isn't it?

Right.

Antoine


-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
