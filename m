Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab3FZJto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:49:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab3FZJtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:49:42 -0400
Date: Wed, 26 Jun 2013 11:49:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: David Herrmann <dh.herrmann@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, Todd Showalter <todd@electronjump.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] input: document gamepad API and add extra
 keycodes
In-Reply-To: <alpine.LNX.2.00.1306190129330.6750@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1306261148580.3538@pobox.suse.cz>
References: <1371303165-1802-1-git-send-email-dh.herrmann@gmail.com> <1371303165-1802-2-git-send-email-dh.herrmann@gmail.com> <alpine.LNX.2.00.1306190129330.6750@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jun 2013, Jiri Kosina wrote:

> On Sat, 15 Jun 2013, David Herrmann wrote:
> 
> > Until today all gamepad input drivers report their data differently. It is
> > nearly impossible to write applications for more than one device in a
> > generic way. Therefore, this patch introduces a uniform gamepad API which
> > will be used for all new drivers.
> > 
> > Instead of mapping buttons by their labels, we now map them by position.
> > This allows applications to work with any gamepad regardless of the labels
> > on the buttons. Furthermore, we standardize the ABS_* codes for analog
> > triggers and sticks.
> > 
> > For D-Pads the long overdue BTN_DPAD_* codes are introduced. They should
> > be fairly obvious how to use. To avoid confusion, the action buttons now
> > have BTN_EAST/SOUTH/WEST/NORTH aliases.
> > 
> > Reported-by: Todd Showalter <todd@electronjump.com>
> > Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> 
> I definitely need to have Dmitry's Ack for this. If he's OK with 1/2, I am 
> fine with 2/2 patch for wiimote and will happily take it through my tree.

Dmitry, please?

I'd like to avoid missing next merge window if you're ok with this.

Thanks again,

-- 
Jiri Kosina
SUSE Labs
