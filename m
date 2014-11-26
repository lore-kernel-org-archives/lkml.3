Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbaKZFY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 00:24:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbaKZFYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 00:24:54 -0500
Message-ID: <54756424.6020409@suse.com>
Date: Wed, 26 Nov 2014 06:24:52 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: the arch/x86 maintainers <x86@kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: frequent lockups in 3.18rc4
References: <20141114213124.GB3344@redhat.com>	<CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>	<20141115213405.GA31971@redhat.com>	<20141116014006.GA5016@redhat.com>	<CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>	<20141126002501.GA11752@redhat.com>	<CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>	<5475596A.9010301@suse.com> <CA+55aFx1SiFBzmA=k9jHxi3cZE3Ei_+2NHepujgf86KEvkz8eQ@mail.gmail.com>
In-Reply-To: <CA+55aFx1SiFBzmA=k9jHxi3cZE3Ei_+2NHepujgf86KEvkz8eQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 06:09 AM, Linus Torvalds wrote:
>
> On Nov 25, 2014 8:39 PM, "Jürgen Groß" <jgross@suse.com
> <mailto:jgross@suse.com>> wrote:
>  >
>  > I COULD trigger it with 3.17. Took much longer, but I've seen it once.
>  > And from Xen hypervisor data it was clear it was the same bug (cpu
>  > spinning in pmd_lock()).
>
> I'm still hoping you can give a back trace. I'd like to know what access
> it is that can trigger this, and preferably what the call chain to it was...

Working on it. Triggering it via sysrq(l) isn't working: machine hung
up. I'll try a dump, but this might take some time due to the machine
size...

If this isn't working I can always modify the hypervisor to show me
more of the kernel stack in that situation. This will be a pure dump,
but it should be possible to extract the back trace from that.

>
> I do believe it happened in 3.17, I just want to understand the but more
> - not just apply the fix..

Sure.

>
> Most of Dave's lockup back traces did not have the whole page fault in
> them, so while Dave has seen this too, there might be different symptoms...

Stay tuned... :-)


Juergen

