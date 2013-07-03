Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933419Ab3GCVDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 17:03:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933054Ab3GCVDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 17:03:47 -0400
Message-ID: <51D491AD.7050008@suse.cz>
Date: Wed, 03 Jul 2013 23:03:41 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jonathan Masters <jcm@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
Subject: Re: [RFC PATCH] Allow optional module parameters
References: <b6b1676fd5bcd6b0ef47b0e0a1c26b1c05684135.1363291511.git.luto@amacapital.net> <87ehfhtftn.fsf@rustcorp.com.au> <CALCETrU+rehQzy4vVg589CGi561X_s73Xgsfp43pYZOoKvNDXQ@mail.gmail.com> <87sj3tsawh.fsf@rustcorp.com.au> <CALCETrUK54KViGex=V2pG8kAttsxOiDkeJUL48pk1NAhH-SdAA@mail.gmail.com> <87hak8qfu5.fsf@rustcorp.com.au> <CAMOw1v5AOmy38KNVfxj6OO-U0UCXST50vD0g0W5fEpNfKCpGvg@mail.gmail.com> <87sj3qpwdz.fsf@rustcorp.com.au> <87a9m6sri3.fsf@rustcorp.com.au> <9F26321B-7088-4D16-80D5-72EB388F8E49@redhat.com>
In-Reply-To: <9F26321B-7088-4D16-80D5-72EB388F8E49@redhat.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 1.7.2013 18:33, Jonathan Masters napsal(a):
> One caveat. Sometimes we have manufactured parameters intentionally
> to cause a module to fail. We should standardize that piece.

You have:

  blacklist foo

to prevent udev from loading a module and

  install foo /bin/true

to prevent modprobe from loading the module at all. What is the
motivation for inventing a third way, through adding invalid parameters?

Thanks,
Michal
