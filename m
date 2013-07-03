Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab3GCQT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:19:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425Ab3GCQT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:19:56 -0400
Date: Wed, 3 Jul 2013 18:19:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus G Thiel <linus@hanssonlarsson.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Patch -- HID definitions for MacBook Air 6,2 keyboard
In-Reply-To: <CAG4XgJSu53FKuYQG+H95wx0pM9UJr1h9SLqVrR3EE6cDhuu4qw@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1307031819080.26857@pobox.suse.cz>
References: <CAG4XgJSu53FKuYQG+H95wx0pM9UJr1h9SLqVrR3EE6cDhuu4qw@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jul 2013, Linus G Thiel wrote:

> Hi,
> 
> Please see attached a patch for the MacBook Air 6,2 keyboard.
> 
> Changelog:
> 
> * add definitions for new MacBook Air 6,2 keyboard with device id
> 0x05ac:0x0291
> 
> I'm not sure about the name I chose for the keyboard -- I just made it the
> "next" wellspring, whatever that means. If it's wrong, let me know and I
> will make it right.
> 
> Signed-off-by: Linus G Thiel <linus@hanssonlarsson.se>

Hi Linus,

thanks for the patch.

Henrik Rydberg however beat you with it, it has been queued in 
input.git#for-linus already.

BTW, please make sure that your future patch submissions follow the rules 
in Documentation/SubmittingPatches.

Thanks,

-- 
Jiri Kosina
SUSE Labs
