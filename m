Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab3F1TgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:36:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42207 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3F1TgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:36:17 -0400
Date: Fri, 28 Jun 2013 14:36:08 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Tejun Heo <tj@kernel.org>, thockin@hockin.org,
        Mike Galbraith <bitbucket@online.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Kay Sievers <kay.sievers@vrfy.org>, lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        jpoimboe <jpoimboe@redhat.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>, cgroups@vger.kernel.org
Subject: Re: cgroup: status-quo and userland efforts
Message-ID: <20130628193608.GA10415@sergelap>
References: <CAAAKZwvh_R2Xz--bmSLiN33fsqKanOJMq_6+6hoFWFRx38O4gA@mail.gmail.com>
 <20130422214159.GG12543@htj.dyndns.org>
 <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
 <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
 <20130625000118.GT1918@mtj.dyndns.org>
 <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org>
 <1372311907.5871.78.camel@marge.simpson.net>
 <20130627180143.GD5599@mtj.dyndns.org>
 <51CDE18E.8080009@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CDE18E.8080009@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andy Lutomirski (luto@amacapital.net):
> On 06/27/2013 11:01 AM, Tejun Heo wrote:
> > AFAICS, having a userland agent which has overall knowledge of the
> > hierarchy and enforcesf structure and limiations is a requirement to
> > make cgroup generally useable and useful.  For systemd based systems,
> > systemd serving that role isn't too crazy.  It's sure gonna have
> > teeting issues at the beginning but it has all the necessary
> > information to manage workloads on the system.
> > 
> > A valid issue is interoperability between systemd and non-systemd
> > systems.  I don't have an immediately good answer for that.  I wrote
> > in another reply but making cgroup generally available is a pretty new
> > effort and we're still in the process of figuring out what the right
> > constructs and abstractions are.  Hopefully, we'll be able to reach a
> > common set of abstractions to base things on top in itme.
> > 
> 
> The systemd stuff will break my code, too (although the single hierarchy
> by itself won't, I think).  I think that the kernel should make whatever
> simple changes are needed so that systemd can function without using
> cgroups at all.  That way users of a different cgroup scheme can turn
> off systemd's.
> 
> Here was my proposal, which hasn't gotten a clear reply:
> 
> http://article.gmane.org/gmane.comp.sysutils.systemd.devel/11424

Neat.  I like that proposal.

> I've already sent a patch to make /proc/<pid>/task/<tid>/children
> available regardless of configuration.

-serge
