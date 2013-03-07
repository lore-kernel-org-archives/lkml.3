Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab3CGGzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 01:55:15 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60920 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751039Ab3CGGzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 01:55:13 -0500
Message-ID: <1362639311.5290.28.camel@joe-AO722>
Subject: Re: [PATCH V2 3/3] get_maintainer: prevent keywords from matching
 filenames
From: Joe Perches <joe@perches.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Lucas Stach <dev@lynxeye.de>, Borislav Petkov <bp@alien8.de>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Date: Wed, 06 Mar 2013 22:55:11 -0800
In-Reply-To: <51383800.7000608@wwwdotorg.org>
References: <1362616141-13947-1-git-send-email-swarren@wwwdotorg.org>
	 <1362616141-13947-3-git-send-email-swarren@wwwdotorg.org>
	 <1362616252.2093.37.camel@joe-AO722> <5137E09E.1060006@wwwdotorg.org>
	 <1362616810.2093.40.camel@joe-AO722> <51383800.7000608@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 23:47 -0700, Stephen Warren wrote:
> On 03/06/2013 05:40 PM, Joe Perches wrote:
> > Which is why I showed the whole thing in a single patch.
> > No worries if it's simply to increase the patch count...
> 
> I'm not sure what showed refers to?

The changes I posted with the suggestion
https://lkml.org/lkml/2013/3/6/468

> I guess if I squashed /everything/ into a single commit (i.e. the change
> to the Tegra section in MAINTAINERS too) then there wouldn't be any
> bisect issues. I really don't care about patch count. The reason for >1
> patch is that there's often push-back if doing logically separate things
> (adding N: feature, modifying a MAINTAINERS entry to use it, removing
> part of K: feature) in a single patch...

Not from me anyway.

I think it's a single logical change and
it's trivial too.

No worries whatever happens.

