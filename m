Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbaKPKGl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 05:06:41 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:37954 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaKPKGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 05:06:39 -0500
Date: Sun, 16 Nov 2014 11:06:36 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141116100636.GA340@x4>
References: <20141114213124.GB3344@redhat.com>
 <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
 <20141115213405.GA31971@redhat.com>
 <20141116014006.GA5016@redhat.com>
 <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.11.15 at 22:33 -0800, Linus Torvalds wrote:
> On Sat, Nov 15, 2014 at 5:40 PM, Dave Jones <davej@redhat.com> wrote:
> >  >
> >  > I'll try that next, and check in on it tomorrow.
> >
> > No luck. Died even faster this time.
> 
> Yeah, and your other lockups haven't even been TLB related. Not that
> they look like anything else *either*.
> 
> I have no ideas left. I'd go for a bisection

Before starting a bisection you could try and disable transparent_hugepages.
There are strange bugs, that were introduced during this merge-window, in this
area. See: https://lkml.org/lkml/2014/11/4/144
https://lkml.org/lkml/2014/11/4/904
http://thread.gmane.org/gmane.linux.kernel.mm/124451

-- 
Markus
