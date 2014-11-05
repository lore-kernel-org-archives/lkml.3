Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaKEUNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:13:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33728 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbaKEUN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:13:27 -0500
Date: Wed, 5 Nov 2014 21:13:26 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Subject: Re: [PATCH v2 06/13] backports: update dependencies map file
Message-ID: <20141105201326.GP12953@wotan.suse.de>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com> <1415157517-15442-7-git-send-email-mcgrof@do-not-panic.com> <1415174051.2589.6.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415174051.2589.6.camel@sipsolutions.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 08:54:11AM +0100, Johannes Berg wrote:
> On Tue, 2014-11-04 at 19:18 -0800, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > During development of kernel integration support using CONFIG_BACKPORT
> > was evaluated as a prefix over CPTCFG even for packaging backports,
> > for some reason this change lifted some restrictions one some device
> > drivers which was present before and as such requires some changes to
> > the dependencies map file to ensure correct compilation for respective
> > kernel versions.
> 
> This is confusing ... I think what you're trying to say is that you
> noticed it because your integration system was broken and not honouring
> restrictions properly?

No I verified each reported case I got and verified the issues found
were valid. For some reason some of these drivers were not allowed to
compile on some older versions, and from what me and Hauke could tell
they should, but they weren't. So the new annotations on requirements
are valid.

 Luis
