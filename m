Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab3CGAkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:40:14 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:34086 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753372Ab3CGAkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:40:12 -0500
Message-ID: <1362616810.2093.40.camel@joe-AO722>
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
Date: Wed, 06 Mar 2013 16:40:10 -0800
In-Reply-To: <5137E09E.1060006@wwwdotorg.org>
References: <1362616141-13947-1-git-send-email-swarren@wwwdotorg.org>
	 <1362616141-13947-3-git-send-email-swarren@wwwdotorg.org>
	 <1362616252.2093.37.camel@joe-AO722> <5137E09E.1060006@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 17:34 -0700, Stephen Warren wrote:
> On 03/06/2013 05:30 PM, Joe Perches wrote:
> > On Wed, 2013-03-06 at 17:29 -0700, Stephen Warren wrote:
> >> From: Stephen Warren <swarren@nvidia.com>
> >>
> >> This reverts most of eb90d08 "get_maintainer: allow keywords to match
> >> filenames"; all except the parts that are required to implement the new
> >> N: entry type.
> > 
> > Just combine patches 1 and 3 into a single patch.
> 
> That would break bisectability; using MAINTAINERS after applying a
> squashed 1+3 but without patch 2 applied would not operate as desired.

<smile>

Which is why I showed the whole thing in a single patch.
No worries if it's simply to increase the patch count...

cheers, Joe

