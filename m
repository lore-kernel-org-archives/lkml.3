Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab3F0FpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 01:45:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62456 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3F0FpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 01:45:19 -0400
Message-ID: <1372311907.5871.78.camel@marge.simpson.net>
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
Date: Thu, 27 Jun 2013 07:45:07 +0200
In-Reply-To: <20130626212047.GB4536@htj.dyndns.org>
References: <20130406012159.GA17159@mtj.dyndns.org>
	 <CAAAKZwvh_R2Xz--bmSLiN33fsqKanOJMq_6+6hoFWFRx38O4gA@mail.gmail.com>
	 <20130422214159.GG12543@htj.dyndns.org>
	 <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
	 <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
	 <20130625000118.GT1918@mtj.dyndns.org>
	 <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
	 <20130626212047.GB4536@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:UfdEJOGfuFfAPuy+bYXpBsdSA33JLpgp+JhZT0/FIii
 B02R4medEeTS+SAIYoLbIe9CHlQqUYWEV/kjpKA/c9HySgihpb
 NkMHc2yYV2OS8WCJZTLYiJ//wmOGtq5MQ6JP+ct7iNxAA8GzlI
 f2p7lTPyY4jHoMe+t7PrUPE0lC5G7jWkxdCZDwwqslSbxp0CSO
 V8e9J4EnwetVhWL0RUA16kFH5B2QIak875FLkvam0Zmm9cFX0I
 Z+QSM+D8OttMGZkNNnXdLZILjpgUh8xKxwuTr+7U3phhKmt3nV
 Lm+Isg0s2LhIRBqjKp49xKnXSRV8zyP0Lgd3jThulrdX/N1IKz
 FgyPa75iwSP7c3tXHnSKi0uCGwLSSWaQMjXton+uFz3LxHvDZp
 wEIQtreBS5Zzw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 14:20 -0700, Tejun Heo wrote: 
> Hello, Tim.
> 
> On Mon, Jun 24, 2013 at 09:07:47PM -0700, Tim Hockin wrote:
> > I really want to understand why this is SO IMPORTANT that you have to
> > break userspace compatibility?  I mean, isn't Linux supposed to be the
> > OS with the stable kernel interface?  I've seen Linus rant time and
> > time again about this - why is it OK now?
> 
> What the hell are you talking about?  Nobody is breaking userland
> interface.  A new version of interface is being phased in and the old
> one will stay there for the foreseeable future.  It will be phased out
> eventually but that's gonna take a long time and it will have to be
> something hardly noticeable.  Of course new features will only be
> available with the new interface and there will be efforts to nudge
> people away from the old one but the existing interface will keep
> working it does.

I can understand some alarm.  When I saw the below I started frothing at
the face and howling at the moon, and I don't even use the things much.

http://lists.freedesktop.org/archives/systemd-devel/2013-June/011521.html

Hierarchy layout aside, that "private property" bit says that the folks
who currently own and use the cgroups interface will lose direct access
to it.  I can imagine folks who have become dependent upon an on the fly
management agents of their own design becoming a tad alarmed.

-Mike

