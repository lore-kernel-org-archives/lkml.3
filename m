Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbaGOPWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:22:43 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55261 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751037AbaGOPWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:22:37 -0400
Date: Tue, 15 Jul 2014 17:22:30 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Peter Chen <Peter.Chen@freescale.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 07/12] usb: chipidea: add a generic driver
Message-ID: <20140715152230.GE1011@kwain>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
 <1403606121-6368-8-git-send-email-antoine.tenart@free-electrons.com>
 <20140627032506.GA18039@shlinux1.ap.freescale.net>
 <20140630133313.GA11880@kwain>
 <20140701002112.GA26146@shlinux1.ap.freescale.net>
 <53B27789.3090509@gmail.com>
 <20140701083007.GB26146@shlinux1.ap.freescale.net>
 <20140701104254.GD3427@piout.net>
 <53B2D151.60404@cogentembedded.com>
 <1d01427f91084d67bf63721e2267e160@BL2PR03MB226.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1d01427f91084d67bf63721e2267e160@BL2PR03MB226.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

On Wed, Jul 02, 2014 at 01:10:00AM +0000, Peter Chen wrote:
> > On 07/01/2014 02:42 PM, Alexandre Belloni wrote:
> > 
> > >>>>> Well, there is nothing specific about the Berlin CI. Some
> > >>>>> subsystems use the 'generic' keyword in these cases. Do you see a
> > >>>>> particular reason I should use some Berlin related compatible here?
> > 
> > >>>> Not must, one suggestion is: can you change the compatible string
> > >>>> to "chipidea-usb-generic"?
> > 
> > >>> I don't know about ChipIdea/ARC/DW's product portfolio but I guess
> > >>> the compatible should also carry '2.0' or 'usb2' in it. Or we just
> > >>> use some version number like 'chipidea,ci13000' or 'chipidea,ci13xxx'.
> > 
> > >> The recommended format for compatible string is:
> > >> "manufacturer,model", I agree with "chipidea,ci13xxx", thanks.
> > 
> > > I think we should probably avoid using wildcards in the compatible
> > > string.
> > 
> >     I'm sure wildcards shouldn't be allowed there. :-)
> 
> Then, what's your guys recommend, how about "chipidea,usb2-generic"?

So what do you think? "chipidea,ci13", "chipidea,usb2-generic" or
something else?

I tend to prefer something without the 'generic' keyword.

After updating the compatible I'll send a v3 based on USB changes
introducing the generic PHY support[1].

[1] https://lkml.org/lkml/2014/7/15/330


Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
