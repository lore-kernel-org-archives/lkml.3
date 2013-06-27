Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3F0Jrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:47:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab3F0Jrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:47:41 -0400
Date: Thu, 27 Jun 2013 11:47:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Herrmann <dh.herrmann@gmail.com>, linux-input@vger.kernel.org,
        Todd Showalter <todd@electronjump.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] input: document gamepad API and add extra
 keycodes
In-Reply-To: <20130626160727.GA32420@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1306271147150.3538@pobox.suse.cz>
References: <1371303165-1802-1-git-send-email-dh.herrmann@gmail.com> <1371303165-1802-2-git-send-email-dh.herrmann@gmail.com> <20130626160727.GA32420@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013, Dmitry Torokhov wrote:

> On Sat, Jun 15, 2013 at 03:32:44PM +0200, David Herrmann wrote:
> > --- a/include/uapi/linux/input.h
> > +++ b/include/uapi/linux/input.h
> > @@ -507,10 +507,14 @@ struct input_keymap_entry {
> >  
> >  #define BTN_GAMEPAD		0x130
> >  #define BTN_A			0x130
> > +#define BTN_SOUTH		0x130
> 
> Could we do:
> 
> #define BTN_SOUTH		0x130
> #define BTN_A			BTN_SOUTH
> 
> so that it is clear that BTN_A, BTN_B, etc are legacy definitions and
> not an accidental typos that need their own key codes.

Makes sense, will do that modification.

> Otherwise:
> 
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Thanks Dmitry. Will be taking it (with the above modification) through my 
tree.

-- 
Jiri Kosina
SUSE Labs
