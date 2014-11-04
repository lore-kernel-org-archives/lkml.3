Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaKDVpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 16:45:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbaKDVpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 16:45:16 -0500
Date: Tue, 4 Nov 2014 22:45:13 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Subject: Re: [PATCH v1 03/11] backports: allow for different backport prefix
Message-ID: <20141104214513.GE12953@wotan.suse.de>
References: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com> <1415090582-14129-4-git-send-email-mcgrof@do-not-panic.com> <1415095517.2064.10.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415095517.2064.10.camel@sipsolutions.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 11:05:17AM +0100, Johannes Berg wrote:
> On Tue, 2014-11-04 at 00:42 -0800, Luis R. Rodriguez wrote:
> 
> > --- a/devel/ckmake
> > +++ b/devel/ckmake
> > @@ -165,6 +165,7 @@ def process_kernel(num, kset, cmdline_args):
> >          all_config_name = os.path.join(work_dir, 'all.config')
> >          all_config = open(all_config_name, 'w')
> >          all_config.write("CPTCFG_CFG80211_INTERNAL_REGDB=n\n")
> > +        all_config.write("CONFIG_BACKPORT_CFG80211_INTERNAL_REGDB=n\n")
> 
> don't you know the prefix here?

Yeah, good point, for built-in I suppose we'll need something different or if
ckmake is extended it would know that too. Dropping this.

  Luis
