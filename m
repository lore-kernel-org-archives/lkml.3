Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936273Ab3DJL0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:26:00 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46294 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762484Ab3DJLZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:25:58 -0400
X-Originating-IP: 83.155.44.161
Message-ID: <1365593153.30420.1.camel@novo>
Subject: Re: [PATCH] HID: appleir: add support for Apple ir devices
From: Bastien Nocera <hadess@hadess.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Fabien <fabien.andre@gmail.com>, Jarod Wilson <jarod@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 10 Apr 2013 13:25:53 +0200
In-Reply-To: <alpine.LNX.2.00.1304092155330.17280@pobox.suse.cz>
References: <1365438651-32623-1-git-send-email-benjamin.tissoires@redhat.com>
	 <alpine.LNX.2.00.1304092155330.17280@pobox.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.0 (3.8.0-1.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 22:10 +0200, Jiri Kosina wrote:
> On Mon, 8 Apr 2013, Benjamin Tissoires wrote:
> 
> > This driver was originally written by James McKenzie, updated by
> > Greg Kroah-Hartman, further updated by Bastien Nocera, with suspend
> > support added.
> > I ported it to the HID subsystem, in order to simplify it a litle
> > and allow lirc to use it through hiddev.
> > 
> > More recent versions of the IR receiver are also supported through
> > a patch by Alex Karpenko. The patch also adds support for the 2nd
> > and 5th generation of the controller, and the menu key on newer
> > brushed metal remotes.
> > 
> > Tested-by: Fabien André <fabien.andre@gmail.com>
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > ---
> > Hi guys,
> > 
> > this is the re-spin of Bastien's patch submitted last november.
> > I ported it to use the hid subsystem, reducing the size of the driver
> > to 355 lines instead of 527.
> 
> Thanks. Generally, I like the idea of appleir being on the hid bus.
> 
> Bastien, could you please provide your Ack (and most importantly also 
> Tested-by?).

At a glance, the patch looks good to me, but I don't have access to
hardware to test this (unsurprisingly given that my original patch is at
least 2 years old).

Cheers


