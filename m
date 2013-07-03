Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335Ab3GCVRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 17:17:38 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:48191 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab3GCVRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 17:17:36 -0400
MIME-Version: 1.0
In-Reply-To: <51D491AD.7050008@suse.cz>
References: <b6b1676fd5bcd6b0ef47b0e0a1c26b1c05684135.1363291511.git.luto@amacapital.net>
 <87ehfhtftn.fsf@rustcorp.com.au> <CALCETrU+rehQzy4vVg589CGi561X_s73Xgsfp43pYZOoKvNDXQ@mail.gmail.com>
 <87sj3tsawh.fsf@rustcorp.com.au> <CALCETrUK54KViGex=V2pG8kAttsxOiDkeJUL48pk1NAhH-SdAA@mail.gmail.com>
 <87hak8qfu5.fsf@rustcorp.com.au> <CAMOw1v5AOmy38KNVfxj6OO-U0UCXST50vD0g0W5fEpNfKCpGvg@mail.gmail.com>
 <87sj3qpwdz.fsf@rustcorp.com.au> <87a9m6sri3.fsf@rustcorp.com.au>
 <9F26321B-7088-4D16-80D5-72EB388F8E49@redhat.com> <51D491AD.7050008@suse.cz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 3 Jul 2013 14:17:15 -0700
Message-ID: <CALCETrWOUE=2fX1k+igfNizUfxRaZCc9NDgMzy7SM6fAjZMZuA@mail.gmail.com>
Subject: Re: [RFC PATCH] Allow optional module parameters
To: Michal Marek <mmarek@suse.cz>
Cc: Jonathan Masters <jcm@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 2:03 PM, Michal Marek <mmarek@suse.cz> wrote:
> Dne 1.7.2013 18:33, Jonathan Masters napsal(a):
>> One caveat. Sometimes we have manufactured parameters intentionally
>> to cause a module to fail. We should standardize that piece.
>
> You have:
>
>   blacklist foo
>
> to prevent udev from loading a module and
>
>   install foo /bin/true
>
> to prevent modprobe from loading the module at all. What is the
> motivation for inventing a third way, through adding invalid parameters?
>

FWIW, I've occasionally booted with modulename.garbage=1 to prevent
modulename from loading at boot.  It may be worth adding a more
intentional way to do that.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
