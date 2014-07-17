Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbaGQMws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:52:48 -0400
Received: from imap.thunk.org ([74.207.234.97]:40786 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046AbaGQMwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:52:47 -0400
Date: Thu, 17 Jul 2014 08:52:36 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140717125236.GM1491@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Tobias Klauser <tklauser@distanz.ch>, linux-kernel@vger.kernel.org,
	linux-abi@vger.kernel.org, linux-crypto@vger.kernel.org,
	beck@openbsd.org
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717120949.GB24362@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717120949.GB24362@distanz.ch>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 02:09:49PM +0200, Tobias Klauser wrote:
> 
> > +/*
> > + * Flags for getrandom(2)
> > + *
> > + * GAND_BLOCK 		Allow getrandom(2) to block
> > + * GAND_RANDOM		Use the /dev/random pool instead of /dev/urandom
> > + */
> 
> Very minor nitpick: These should probably read GRND_BLOCK/GRND_RANDOM as
> well, no?

Thanks, typo.  I'll get this fixed up.

	       	    	     	   - Ted
