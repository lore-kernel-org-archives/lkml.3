Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaKZFLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 00:11:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbaKZFLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 00:11:45 -0500
Date: Wed, 26 Nov 2014 00:11:31 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141126051131.GA21318@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	=?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20141114213124.GB3344@redhat.com>
 <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
 <20141115213405.GA31971@redhat.com>
 <20141116014006.GA5016@redhat.com>
 <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
 <20141126002501.GA11752@redhat.com>
 <CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>
 <5475596A.9010301@suse.com>
 <CA+55aFx1SiFBzmA=k9jHxi3cZE3Ei_+2NHepujgf86KEvkz8eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFx1SiFBzmA=k9jHxi3cZE3Ei_+2NHepujgf86KEvkz8eQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 09:09:45PM -0800, Linus Torvalds wrote:
 > On Nov 25, 2014 8:39 PM, "Jürgen Groß" <jgross@suse.com> wrote:
 > >
 > > I COULD trigger it with 3.17. Took much longer, but I've seen it once.
 > > And from Xen hypervisor data it was clear it was the same bug (cpu
 > > spinning in pmd_lock()).
 > 
 > I'm still hoping you can give a back trace. I'd like to know what access it
 > is that can trigger this, and preferably what the call chain to it was...
 > 
 > I do believe it happened in 3.17, I just want to understand the but more -
 > not just apply the fix..
 > 
 > Most of Dave's lockup back traces did not have the whole page fault in
 > them, so while Dave has seen this too, there might be different symptoms...

Before giving 3.17 a multi-day workout, I'll try rc6 with Jürgen's patch
to see if that makes any difference at all for me.

	Dave

