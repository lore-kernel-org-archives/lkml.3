Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3GHRVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 13:21:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40244 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752027Ab3GHRVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 13:21:44 -0400
Message-ID: <1373304103.9458.2.camel@joe-AO722>
Subject: Re: [dm-devel] [PATCH] MAINTAINERS: dm-devel@redhat.com is a list
From: Joe Perches <joe@perches.com>
To: Alasdair G Kergon <agk@redhat.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Date: Mon, 08 Jul 2013 10:21:43 -0700
In-Reply-To: <20130708171009.GA4870@agk-dp.fab.redhat.com>
References: <1372777307-4259-1-git-send-email-ydroneaud@opteya.com>
	 <20130708171009.GA4870@agk-dp.fab.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-08 at 18:10 +0100, Alasdair G Kergon wrote:
> On Tue, Jul 02, 2013 at 05:01:47PM +0200, Yann Droneaud wrote:
> > This patch changes type of dm-devel@redhat.com
> > The output of ./scripts/get_maintainer.pl is
> > modified to report dm-devel@redhat.com as a list:
>  
> >  DEVICE-MAPPER  (LVM)
> >  M:	Alasdair Kergon <agk@redhat.com>
> > -M:	dm-devel@redhat.com
> >  L:	dm-devel@redhat.com
> >  W:	http://sources.redhat.com/dm
> >  Q:	http://patchwork.kernel.org/project/dm-devel/list/

I think this Q entry isn't as useful as it could be
because it doesn't show the status of any patch.

It looks as if every patch ever sent to dm-devel is
still listed as "new".


