Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3J2I0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:26:45 -0400
Received: from mx2.imag.fr ([129.88.30.17]:57436 "EHLO rominette.imag.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648Ab3J2I0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:26:42 -0400
From: Matthieu Moy <Matthieu.Moy@grenoble-inp.fr>
To: Jeff King <peff@peff.net>
Cc: Johan Herland <johan@herland.net>, Michael Haggerty <mhagger@alum.mit.edu>,
        Josh Triplett <josh@joshtriplett.org>,
        Git mailing list <git@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, Greg KH <greg@kroah.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        ksummit-attendees@lists.linuxfoundation.org,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] commit: Add -f, --fixes <commit> option to add Fixes: line
References: <20131024122255.GI9378@mwanda> <20131024122512.GB9534@mwanda>
	<20131026181709.GB10488@kroah.com> <20131027013402.GA7146@leaf>
	<526CA7D4.1070904@alum.mit.edu> <20131027071407.GA11683@leaf>
	<526E283A.1070801@alum.mit.edu>
	<CALKQrgfsk3fjyF77XL9+CPyJ_s-AfzkNAj4Eaj1LT-G0Ph=bfg@mail.gmail.com>
	<20131029020824.GE11861@sigill.intra.peff.net>
Date: Tue, 29 Oct 2013 09:26:14 +0100
In-Reply-To: <20131029020824.GE11861@sigill.intra.peff.net> (Jeff King's
	message of "Mon, 28 Oct 2013 22:08:24 -0400")
Message-ID: <vpqfvrkeb4p.fsf@anie.imag.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.2 (rominette.imag.fr [129.88.30.17]); Tue, 29 Oct 2013 09:26:15 +0100 (CET)
X-IMAG-MailScanner-Information: Please contact MI2S MIM  for more information
X-MailScanner-ID: r9T8QENj004279
X-IMAG-MailScanner: Found to be clean
X-IMAG-MailScanner-SpamCheck: 
X-IMAG-MailScanner-From: matthieu.moy@grenoble-inp.fr
MailScanner-NULL-Check: 1383639977.58656@6SqBwupxyjeGbuYGDVtwJQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff King <peff@peff.net> writes:

>  We could probably make this friendlier by reading from ~/.githooks
> and defining some semantics for multiple hooks.

I'd be all for it, except I'd call this ~/.config/git/hooks/* (or
$XDG_CONFIG_HOME if set).

> E.g., fall back to ~/.githooks if the repo hook is not
> executable, or possibly run them both

I think running them both would be the best option. Otherwise, adding a
(possibly trivial) hook to a repo would disable the user-wide one,
that'd feel weird.

-- 
Matthieu Moy
http://www-verimag.imag.fr/~moy/
