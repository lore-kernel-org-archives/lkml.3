Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab3GOXkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 19:40:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758437Ab3GOXkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 19:40:31 -0400
Date: Tue, 16 Jul 2013 01:40:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <greg@kroah.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        James.Bottomley@HansenPartnership.com
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
In-Reply-To: <alpine.LNX.2.00.1307160011530.29788@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1307160131420.29788@pobox.suse.cz>
References: <1373916476.2748.69.camel@dabdike> <20130715214422.GA2478@kroah.com> <alpine.LNX.2.00.1307160011530.29788@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013, Jiri Kosina wrote:

> (*) For me personally, the best mode of operation would actually be to 
>     have for-stable/3.x branches in my git tree, cherry-pick from other 
>     topic branches once the patches are in Linus' tree, and send you pull 
>     request for stable regularly (for each stable branch separately of 
>     course)
>    
>     This model would make maintainers clearly responsible for the contents 
>     of stable tree, wouldn't cause any extra work for you (quite the 
>     contrary, I'd say), and it'd follow the development model we have for
>     Linus' tree.

... and it will actually have a nice self-regulatory feature (in case 
maintainers who are pushing too much stuff your way are part of the 
problem).

Preparing a proper pull request requires much more care, "stopping and 
thinking for a while", formulating the pull request, than just blindly 
tossing "Cc: stable" everywhere in a headless-chicken mode.

To sum it up:

- if the maintainers really do care about their patches being in the 
  -stable tree, this wouldn't cost them too much extra time

- if they are just randomly pushing everything to -stable because "hey, 
  why not", this will be an extra hurdle for them to overcome, and they 
  will be revealed easily by poor pull request justification

- if the maintainers are lazy and don't care about preparing stable 
  branches, it's their responsibility (and their shame) that -stable will 
  be missing the code they are responsible for

- it offloads the work from single point of failure (you) to the 
  maintainers, which makes a lot of sense to me

- it aligns the workflow with the workflow that's in place for Linus' 
  already (and not only there) to be more or less a proper git workflow

-- 
Jiri Kosina
SUSE Labs
