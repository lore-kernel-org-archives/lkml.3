Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab3GCBQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 21:16:07 -0400
Received: from ozlabs.org ([203.10.76.45]:33246 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab3GCBQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 21:16:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jonathan Masters <jcm@redhat.com>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "linux-kbuild\@vger.kernel.org" <linux-kbuild@vger.kernel.org>
Subject: Re: [RFC PATCH] Allow optional module parameters
In-Reply-To: <9F26321B-7088-4D16-80D5-72EB388F8E49@redhat.com>
References: <b6b1676fd5bcd6b0ef47b0e0a1c26b1c05684135.1363291511.git.luto@amacapital.net> <87ehfhtftn.fsf@rustcorp.com.au> <CALCETrU+rehQzy4vVg589CGi561X_s73Xgsfp43pYZOoKvNDXQ@mail.gmail.com> <87sj3tsawh.fsf@rustcorp.com.au> <CALCETrUK54KViGex=V2pG8kAttsxOiDkeJUL48pk1NAhH-SdAA@mail.gmail.com> <87hak8qfu5.fsf@rustcorp.com.au> <CAMOw1v5AOmy38KNVfxj6OO-U0UCXST50vD0g0W5fEpNfKCpGvg@mail.gmail.com> <87sj3qpwdz.fsf@rustcorp.com.au> <87a9m6sri3.fsf@rustcorp.com.au> <9F26321B-7088-4D16-80D5-72EB388F8E49@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 03 Jul 2013 09:58:49 +0930
Message-ID: <87k3l8fpvi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Masters <jcm@redhat.com> writes:
> One caveat. Sometimes we have manufactured parameters intentionally to cause a module to fail. We should standardize that piece.

Certainly.  Can you give an example?

Cheers,
Rusty.
