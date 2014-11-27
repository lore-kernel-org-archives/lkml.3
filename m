Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbaK0AqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 19:46:21 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:52145 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbaK0AqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 19:46:19 -0500
MIME-Version: 1.0
In-Reply-To: <20141126225745.GA30346@redhat.com>
References: <20141114213124.GB3344@redhat.com>
	<CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
	<20141115213405.GA31971@redhat.com>
	<20141116014006.GA5016@redhat.com>
	<CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
	<20141126002501.GA11752@redhat.com>
	<CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>
	<20141126024032.GA13246@redhat.com>
	<20141126225745.GA30346@redhat.com>
Date: Wed, 26 Nov 2014 16:46:18 -0800
X-Google-Sender-Auth: 4Nf_HcY9Qp9FAV_TvUB1nQO3dj0
Message-ID: <CA+55aFwripPcJiVMz-h5F23SyQPhnVygYDyX+D9Em=EvryUbEw@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 2:57 PM, Dave Jones <davej@redhat.com> wrote:
>
> So 3.17 also has this problem.
> Good news I guess in that it's not a regression, but damn I really didn't
> want to have to go digging through the mists of time to find the last 'good' point.
> At least it shouldn't hold up 3.18

Ugh. That still doesn't make me very happy.

I'll try to think about this more.

                  Linus
