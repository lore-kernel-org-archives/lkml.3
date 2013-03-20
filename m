Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830Ab3CTDNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 23:13:47 -0400
Received: from ozlabs.org ([203.10.76.45]:47604 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933340Ab3CTDNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 23:13:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Jon Masters <jcm@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [RFC PATCH] Allow optional module parameters
In-Reply-To: <1363722051.3491.29.camel@bwh-desktop.uk.solarflarecom.com>
References: <b6b1676fd5bcd6b0ef47b0e0a1c26b1c05684135.1363291511.git.luto@amacapital.net> <87ehfhtftn.fsf@rustcorp.com.au> <CALCETrU+rehQzy4vVg589CGi561X_s73Xgsfp43pYZOoKvNDXQ@mail.gmail.com> <87sj3tsawh.fsf@rustcorp.com.au> <CALCETrUK54KViGex=V2pG8kAttsxOiDkeJUL48pk1NAhH-SdAA@mail.gmail.com> <87hak8qfu5.fsf@rustcorp.com.au> <1363722051.3491.29.camel@bwh-desktop.uk.solarflarecom.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 20 Mar 2013 13:01:01 +1030
Message-ID: <87zjxypztm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <bhutchings@solarflare.com> writes:
> This should also go to stable, so the downgrading issue doesn't continue
> to bite people.

Andy was complaining about experimental params going away: I haven't
heard a single complaint about the downgrading issue.  I think it's a
nice to have, which is why I mentioned it.  I also CC'd the two
maintainers most likely to know if it *is* a current problem.  And note
that this code has been this way for over ten years!

No bug report, no cc:stable.

What if people were relying on detecting module parameters by the load
failing?  I'd rather find out when they upgrade to a new kernel instead
of poisoning the old ones, too.

Cheers,
Rusty.
