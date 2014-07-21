Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaGUWYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 18:24:53 -0400
Received: from imap.thunk.org ([74.207.234.97]:48470 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbaGUWYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 18:24:51 -0400
Date: Mon, 21 Jul 2014 18:23:22 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org,
        deraadt@cvs.openbsd.org
Subject: Re: [PATCH -v4] random: introduce getrandom(2) system call
Message-ID: <20140721222322.GC24960@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-crypto@vger.kernel.org, beck@openbsd.org,
	deraadt@cvs.openbsd.org
References: <1405718127-30042-1-git-send-email-tytso@mit.edu>
 <20140721202125.GF1158@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721202125.GF1158@osiris>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 10:21:26PM +0200, Till Smejkal wrote:
> Hi,
> 
> On Fri, 18 Jul 2014, Theodore Ts'o wrote:
> [...]
> > 	If the GRND_RANDOM bit is not set, then the /dev/urandom pool
> > 	will be used.  Unlike using read(2) to fetch data from
> > 	/dev/urandom, if the urandom pool has not been sufficiently
> > 	initialized, getrandom(2) will block or return -1 with the
> > 	errno set to EGAIN if the GRND_NONBLOCK bit is set in flags.
>                  ^^^^^
> Small typo: this should be EAGAIN.

Thanks for pointing this out!  Will fix.

					- Ted
