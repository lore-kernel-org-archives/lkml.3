Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab3F1GAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 02:00:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58606 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab3F1GAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 02:00:19 -0400
Message-ID: <1372399204.5989.166.camel@marge.simpson.net>
Subject: Re: cgroup: status-quo and userland efforts
From: Mike Galbraith <bitbucket@online.de>
To: Tejun Heo <tj@kernel.org>
Cc: Tim Hockin <thockin@hockin.org>, Li Zefan <lizefan@huawei.com>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>, bsingharora <bsingharora@gmail.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, jpoimboe <jpoimboe@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 28 Jun 2013 08:00:04 +0200
In-Reply-To: <20130628050138.GD2500@htj.dyndns.org>
References: <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
	 <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
	 <20130625000118.GT1918@mtj.dyndns.org>
	 <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
	 <20130626212047.GB4536@htj.dyndns.org>
	 <1372311907.5871.78.camel@marge.simpson.net>
	 <20130627180143.GD5599@mtj.dyndns.org>
	 <1372391198.5989.110.camel@marge.simpson.net>
	 <20130628040930.GC2500@htj.dyndns.org>
	 <1372394950.5989.128.camel@marge.simpson.net>
	 <20130628050138.GD2500@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:6q38eHmuI37AFlvd7DjrM1+U5kdkciCo+R8Nkb9Wyy3
 qKhOopENPkhTEPdwmRTFCUHonplDQ/8Hq0/MbdqdPnlF3csblb
 vWXPlnyUH4wtwzSkXEu25wI16nr8f6BDU4mgkFVAr/2DsOXkOy
 67xhwhvNaRDsLR5mFupvxTLZMJ6a57bujqdY/BZiuYeD7QBe2k
 SXDDbfitPghWRKvQ+pB1PXIhtzUSGyvgmV+iWtHz9z+lB8HLTJ
 V7x8OqFzb6nL1PhbQB07NgI5JZD+ojcRU64AsLEtxR4F/N67AU
 Gt5QoBI6V5hRU5lk4UAQTE3BZqmTEfsH7BoFYYc1NBQKkJ+WJB
 dQaMm4glP6RNAHYYKg0UvOsXVUa+R22eajbYVDJ/9xbO8kLdLy
 uXDiR2aRbVRSg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 22:01 -0700, Tejun Heo wrote:

> Anyways, if you're root, you can keep doing whatever you want.  You
> could be stepping on the centralized agent's toes a bit and vice-versa

Keep on truckn' sounds good, that vice-versa toe stomping not so good,
but yeah, until systemd or ilk grows the ability to shut me down, I
shouldn't feel any burning need to introduce it to my machete.

> but I don't think that's gonna be disastrous.  What I'm trying to
> stamp out is direct usages from !root domains and !system-management
> binaries / scripts.  They absolutely have to go.  There's no question
> about it and I'll take totalitarian userland agent anyday over the
> current mess.

I get some of the why.. and yeah, it's the dirt simple usage that I care
about most, not the big hairy problem cases you're trying to address. 

> Eventually, I think we'll be able to reach an equilibrium where most
> things are reasonable and we'll be exploring the acceptable limits of
> flexibility again, but right now, please bear with the brutality.
> We're way over the line and I can't see a way back which isn't gonna
> sting a bit.  I'm and will keep trying to make it as painless as
> possible.

Keep on driving, and thanks for listening.  Aaaooooo ;-)

-Mike

