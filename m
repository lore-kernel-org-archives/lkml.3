Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab3EJCpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 22:45:45 -0400
Received: from 87-119-183-129.tll.elisa.ee ([87.119.183.129]:53753 "EHLO
	fatphil.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab3EJCpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 22:45:44 -0400
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 May 2013 22:45:43 EDT
Date: Fri, 10 May 2013 05:37:26 +0300
From: Phil Carmody <fatphil@asdf.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Phil Carmody <pc+lkml@asdf.org>, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Makefile: make sparse (CHECK) user-selectable
Message-ID: <20130510023726.GQ21274@fatphil.org>
References: <1368026580-26897-1-git-send-email-pc+lkml@asdf.org> <518A8EE6.90206@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518A8EE6.90206@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/13 10:44 -0700, Randy Dunlap wrote:
> On 05/08/13 08:23, Phil Carmody wrote:
> > I've got a tweaked version as well as the system default,
> > so make the sparse binary that's run user-selectable.
> > 
> 
> I'm confused about why this patch is necessary since I already do
> 
> $ make O=builddir CHECK=/path/to/sparse all

Ach, OK. I was presuming that I should be able to select my sparse
in the same way that I select my cross compiler, namely in the ENV.

CROSS_COMPILE=whatever- CHECK=/my/sparse make C=1

Doctor - it hurts when I do >this<, ouch.
Well, don't do that then!

Phil
-- 
"In a world of magnets and miracles" 
-- Insane Clown Posse, Miracles, 2009. Much derided.
"Magnets, how do they work"
-- Pink Floyd, High Hopes, 1994. Lauded as lyrical geniuses.
