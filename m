Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109Ab3ECI1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 04:27:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab3ECI1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 04:27:31 -0400
Date: Fri, 3 May 2013 10:27:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Simon Wood <simon@mungewell.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH-V2] HID: hid-steelseries fix led class build issue
In-Reply-To: <1367545394-3741-1-git-send-email-simon@mungewell.org>
Message-ID: <alpine.LNX.2.00.1305031027190.11002@pobox.suse.cz>
References: <alpine.DEB.2.02.1305021455260.941@chino.kir.corp.google.com> <1367545394-3741-1-git-send-email-simon@mungewell.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, Simon Wood wrote:

> Fixes 'undefined reference' issue when hid-steelseries is built in,
> but led-class is a module.
> --
> drivers/built-in.o: In function `steelseries_srws1_remove':
> hid-steelseries.c:(.text+0x3b97a1): undefined reference to `led_classdev_unregister'
> drivers/built-in.o: In function `steelseries_srws1_probe':
> hid-steelseries.c:(.text+0x3b9c51): undefined reference to `led_classdev_register'
> hid-steelseries.c:(.text+0x3b9ce5): undefined reference to `led_classdev_register'
> hid-steelseries.c:(.text+0x3b9d4b): undefined reference to `led_classdev_unregister'
> --
> 
> Patch allows LED control when led-class is built in, or both hid-steelseries
> _and_ led-class are both modules.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Simon Wood <simon@mungewell.org>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
