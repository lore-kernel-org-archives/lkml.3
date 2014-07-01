Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbaGAKm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 06:42:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34101 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751930AbaGAKm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 06:42:58 -0400
Date: Tue, 1 Jul 2014 12:42:54 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Peter Chen <peter.chen@freescale.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/12] usb: chipidea: add a generic driver
Message-ID: <20140701104254.GD3427@piout.net>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
 <1403606121-6368-8-git-send-email-antoine.tenart@free-electrons.com>
 <20140627032506.GA18039@shlinux1.ap.freescale.net>
 <20140630133313.GA11880@kwain>
 <20140701002112.GA26146@shlinux1.ap.freescale.net>
 <53B27789.3090509@gmail.com>
 <20140701083007.GB26146@shlinux1.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701083007.GB26146@shlinux1.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 at 16:30:08 +0800, Peter Chen wrote :
> > >>Well, there is nothing specific about the Berlin CI. Some subsystems
> > >>use the 'generic' keyword in these cases. Do you see a particular reason
> > >>I should use some Berlin related compatible here?
> > >
> > >Not must, one suggestion is: can you change the compatible string
> > >to "chipidea-usb-generic"?
> > 
> > I don't know about ChipIdea/ARC/DW's product portfolio but I guess
> > the compatible should also carry '2.0' or 'usb2' in it. Or we just
> > use some version number like 'chipidea,ci13000' or 'chipidea,ci13xxx'.
> > 
> 
> The recommended format for compatible string is: "manufacturer,model",
> I agree with "chipidea,ci13xxx", thanks.
> 

I think we should probably avoid using wildcards in the compatible
string.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
