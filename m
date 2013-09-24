Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab3IXBWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 21:22:22 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:61831 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab3IXBWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 21:22:17 -0400
MIME-Version: 1.0
In-Reply-To: <1379981085.2060.18.camel@buesod1.americas.hpqcorp.net>
References: <1379300677-24188-1-git-send-email-davidlohr@hp.com>
	<1379625742.2145.19.camel@buesod1.americas.hpqcorp.net>
	<1379700524.5434.22.camel@flatline.rdu.redhat.com>
	<1379788235.2145.48.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFwQp6Fm9-Zrn3uue9bFe9tERCbVv5Z-z9r4ZgOmS0VB+Q@mail.gmail.com>
	<1379918525.2231.0.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFzVnivKb=nwzeTjGvi=LvnBLGnr=NZE+Ns6kLSm=WCN4w@mail.gmail.com>
	<1379981085.2060.18.camel@buesod1.americas.hpqcorp.net>
Date: Mon, 23 Sep 2013 18:22:17 -0700
X-Google-Sender-Auth: Nfq1hcFzfIR38rCiC2o9uVlaubQ
Message-ID: <CA+55aFxLi7PNP-4-ouoPJYjOhRCttsP6YxbCHgE2+PNee3hVGg@mail.gmail.com>
Subject: Re: [PATCH 0/4] ipc: shm and msg fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Eric Paris <eparis@parisplace.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 5:04 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>
> Ok, so here's the code - again I've tested it with LTP on the resources
> I have.

This looks good to me.

Manfred, mind giving this a look-over and see if this resolves your
race concerns too?

              Linus
