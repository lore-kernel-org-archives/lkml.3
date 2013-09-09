Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3IIRo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:44:56 -0400
Received: from cobra.newdream.net ([66.33.216.30]:48907 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab3IIRoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:44:54 -0400
Date: Mon, 9 Sep 2013 10:44:53 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Milosz Tanski <milosz@adfin.com>
cc: David Howells <dhowells@redhat.com>, sprabhu@redhat.com,
        ceph-devel <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Hongyi Jia <jiayisuse@gmail.com>,
        "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] ceph: fscache support & upstream changes
In-Reply-To: <CANP1eJG=Eq5w6XdFmrm+xxv7N3BVJgZ0+SxcCTpc45HSKH7DFA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1309091042520.18214@cobra.newdream.net>
References: <cover.1378418255.git.milosz@adfin.com> <alpine.DEB.2.00.1309051555250.1073@cobra.newdream.net> <CANP1eJEk=eRmq1F+yYWB53spgifbU+zzKGdmKw6BGfx8SknkrA@mail.gmail.com> <18764.1378483142@warthog.procyon.org.uk> <CANP1eJFMdcsgSwVO9jhYQwn2C+19db1uy5=du7yYFbmiB6em0A@mail.gmail.com>
 <alpine.DEB.2.00.1309061302300.12830@cobra.newdream.net> <CANP1eJFtF7sRJkqg0xGqNjEzbz29GWywB8DAjfGFzDhCPSfjcg@mail.gmail.com> <CANP1eJF9oyfTWL1up38cEFyQFZQU51v1Yo1wZqFYxN2qkvc7gQ@mail.gmail.com> <13625.1378721932@warthog.procyon.org.uk>
 <CANP1eJG=Eq5w6XdFmrm+xxv7N3BVJgZ0+SxcCTpc45HSKH7DFA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013, Milosz Tanski wrote:
> David,
> 
> I guess that's really a better question for Sage. He sent my branch
> (which includes your changes) plus a whole slew of things over to
> Linus. I'm going guess that a small follow on patch is simplest but
> I'll let him comment.
> 
> Here's the original pull request:
> http://marc.info/?l=linux-kernel&m=137849853203101&w=2

...and Linus just merged it a few minutes ago.  This'll have to be a 
separate patch.  Sorry!

I have another pile of Ceph fixes that I will be sending in a week or so; 
let me know if you want me include the fix there.

Thanks!
sage

> 
> Also, so far after making this change everything is peachy and theres
> no other regressions.
> 
> P.S: This is a resend because I did no hit reply to ALL, sorry for the
> spam David.
> 
> On Mon, Sep 9, 2013 at 6:18 AM, David Howells <dhowells@redhat.com> wrote:
> > Milosz Tanski <milosz@adfin.com> wrote:
> >
> >> I think that change does the trick. I had it running on the same
> >> machine for 5 hours and had the kernel forcefully drop some of the
> >> inodes in the cache (via drop caches) without a crash. I'll send a
> >> proper patch email after you take a look and make sure I did the right
> >> thing.
> >
> > Do you mind if I roll your change directly into my patch and reissue the set?
> > Or would you rather have an extra patch at this time?
> >
> > David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
