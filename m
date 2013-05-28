Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243Ab3E1XN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 19:13:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758127Ab3E1XNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 19:13:25 -0400
Date: Wed, 29 May 2013 01:13:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Petr Ostadal <postadal@suse.cz>, Oliver Neukum <oliver@neukum.org>,
        Vojtech Pavlik <vojtech@suse.cz>, Egbert Eich <eich@suse.com>,
        Libor Pechacek <lpechacek@suse.cz>
Subject: Re: [PATCH 1/2] HID: elo-hid, add driver for ELO 4000/4500
In-Reply-To: <1367919659-1548-1-git-send-email-jslaby@suse.cz>
Message-ID: <alpine.LNX.2.00.1305290112360.12103@pobox.suse.cz>
References: <1367919659-1548-1-git-send-email-jslaby@suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 May 2013, Jiri Slaby wrote:

> This is a driver for ELO 4000/4500 devices which report themselves as
> HID devices, but do not really send HID events on touch. So we
> introduce a new HID 'quirk' driver with a raw_event handler where we
> take care of those events.
> 
> What we need additionally is an input_configured hook, because the
> device does not mention anything about PRESSURE and TOUCH in its
> report descriptor, but it actually generate those. So we set the bits
> in the corresponding input_dev in that hook.
> 
> Thanks to Petr Ostadal who was willing to test the driver. The rest of
> Cc's listed below had something to do with that driver over the years
> in our enterprise tree. Please speak up if you see any problems ;).
> 
> This is the first part. The quirks for broken firmware are added in
> 2/2.

Applied for 3.11. Thanks Jiri for pushing this.

-- 
Jiri Kosina
SUSE Labs
