Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab3CIIyE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 03:54:04 -0500
Received: from www17.your-server.de ([213.133.104.17]:60434 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab3CIIyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 03:54:02 -0500
Message-ID: <1362819234.1220.1.camel@localhost.localdomain>
Subject: Re: [3.9-rc1] irq 16: nobody cared  (was [3.9-rc1] very poor
 interrupt responses)
From: Thomas Meyer <thomas@m3y3r.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Shawn Starr <shawn.starr@rogers.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Date: Sat, 09 Mar 2013 09:53:54 +0100
In-Reply-To: <Pine.LNX.4.44L0.1303082116310.28403-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1303082116310.28403-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 08.03.2013, 21:19 -0500 schrieb Alan Stern:
> On Fri, 8 Mar 2013, Peter Hurley wrote:
> 
> > [ +linux-usb ]
> > 
> > On Fri, 2013-03-08 at 14:12 -0500, Shawn Starr wrote:
> > > Hello folks,
> > > 
> > > I am noticing since rc0 and now rc1, very poor interrupt handling. Keyboard response, mouse movements, display refreshing etc. General input/display sluggishness. Did something break IRQ handling somewhere? I need to validate if this happens with X not running also if it is i915 related somehow. The behavor is noticed in a console login however.
> > > 
> > > Device: Lenovo W500 laptop
> > 
> > Hi Shawn,
> > 
> > Unhandled interrupts is the problem.
> > 
> > Is the device below being id'd properly?
> > If you remove this device, does the problem go away?
> 
> Does either of the kernels in question have commit 0f815a0a700b (USB:
> UHCI: fix IRQ race during initialization)?  That commit was added to
> fix precisely this sort of thing.

I think so:

$ git describe
v3.9-rc1-211-g47b3bc9

$ git branch --contains 0f815a0a700b
* master

> 
> Alan Stern
> 



