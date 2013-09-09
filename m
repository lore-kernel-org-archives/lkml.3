Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3IIOxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:53:18 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:40295 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab3IIOxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:53:16 -0400
MIME-Version: 1.0
In-Reply-To: <13625.1378721932@warthog.procyon.org.uk>
References: <cover.1378418255.git.milosz@adfin.com>
	<alpine.DEB.2.00.1309051555250.1073@cobra.newdream.net>
	<CANP1eJEk=eRmq1F+yYWB53spgifbU+zzKGdmKw6BGfx8SknkrA@mail.gmail.com>
	<18764.1378483142@warthog.procyon.org.uk>
	<CANP1eJFMdcsgSwVO9jhYQwn2C+19db1uy5=du7yYFbmiB6em0A@mail.gmail.com>
	<alpine.DEB.2.00.1309061302300.12830@cobra.newdream.net>
	<CANP1eJFtF7sRJkqg0xGqNjEzbz29GWywB8DAjfGFzDhCPSfjcg@mail.gmail.com>
	<CANP1eJF9oyfTWL1up38cEFyQFZQU51v1Yo1wZqFYxN2qkvc7gQ@mail.gmail.com>
	<13625.1378721932@warthog.procyon.org.uk>
Date: Mon, 9 Sep 2013 10:53:14 -0400
Message-ID: <CANP1eJG=Eq5w6XdFmrm+xxv7N3BVJgZ0+SxcCTpc45HSKH7DFA@mail.gmail.com>
Subject: Re: [PATCH 0/8] ceph: fscache support & upstream changes
From: Milosz Tanski <milosz@adfin.com>
To: David Howells <dhowells@redhat.com>
Cc: sprabhu@redhat.com, ceph-devel <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Hongyi Jia <jiayisuse@gmail.com>,
        "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Sage Weil <sage@inktank.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

I guess that's really a better question for Sage. He sent my branch
(which includes your changes) plus a whole slew of things over to
Linus. I'm going guess that a small follow on patch is simplest but
I'll let him comment.

Here's the original pull request:
http://marc.info/?l=linux-kernel&m=137849853203101&w=2

Also, so far after making this change everything is peachy and theres
no other regressions.

P.S: This is a resend because I did no hit reply to ALL, sorry for the
spam David.

On Mon, Sep 9, 2013 at 6:18 AM, David Howells <dhowells@redhat.com> wrote:
> Milosz Tanski <milosz@adfin.com> wrote:
>
>> I think that change does the trick. I had it running on the same
>> machine for 5 hours and had the kernel forcefully drop some of the
>> inodes in the cache (via drop caches) without a crash. I'll send a
>> proper patch email after you take a look and make sure I did the right
>> thing.
>
> Do you mind if I roll your change directly into my patch and reissue the set?
> Or would you rather have an extra patch at this time?
>
> David
