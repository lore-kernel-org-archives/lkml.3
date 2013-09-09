Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab3IIKTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:19:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab3IIKS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:18:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CANP1eJF9oyfTWL1up38cEFyQFZQU51v1Yo1wZqFYxN2qkvc7gQ@mail.gmail.com>
References: <CANP1eJF9oyfTWL1up38cEFyQFZQU51v1Yo1wZqFYxN2qkvc7gQ@mail.gmail.com> <cover.1378418255.git.milosz@adfin.com> <alpine.DEB.2.00.1309051555250.1073@cobra.newdream.net> <CANP1eJEk=eRmq1F+yYWB53spgifbU+zzKGdmKw6BGfx8SknkrA@mail.gmail.com> <18764.1378483142@warthog.procyon.org.uk> <CANP1eJFMdcsgSwVO9jhYQwn2C+19db1uy5=du7yYFbmiB6em0A@mail.gmail.com> <alpine.DEB.2.00.1309061302300.12830@cobra.newdream.net> <CANP1eJFtF7sRJkqg0xGqNjEzbz29GWywB8DAjfGFzDhCPSfjcg@mail.gmail.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: dhowells@redhat.com, sprabhu@redhat.com,
        ceph-devel <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Hongyi Jia <jiayisuse@gmail.com>,
        "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Sage Weil <sage@inktank.com>
Subject: Re: [PATCH 0/8] ceph: fscache support & upstream changes
Date: Mon, 09 Sep 2013 11:18:52 +0100
Message-ID: <13625.1378721932@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> wrote:

> I think that change does the trick. I had it running on the same
> machine for 5 hours and had the kernel forcefully drop some of the
> inodes in the cache (via drop caches) without a crash. I'll send a
> proper patch email after you take a look and make sure I did the right
> thing.

Do you mind if I roll your change directly into my patch and reissue the set?
Or would you rather have an extra patch at this time?

David
