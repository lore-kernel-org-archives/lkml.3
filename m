Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab3GHRKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 13:10:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab3GHRKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 13:10:23 -0400
Date: Mon, 8 Jul 2013 18:10:09 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] MAINTAINERS: dm-devel@redhat.com is a list
Message-ID: <20130708171009.GA4870@agk-dp.fab.redhat.com>
Mail-Followup-To: Yann Droneaud <ydroneaud@opteya.com>,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com
References: <1372777307-4259-1-git-send-email-ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372777307-4259-1-git-send-email-ydroneaud@opteya.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 05:01:47PM +0200, Yann Droneaud wrote:
> This patch changes type of dm-devel@redhat.com
> The output of ./scripts/get_maintainer.pl is
> modified to report dm-devel@redhat.com as a list:
 
>  DEVICE-MAPPER  (LVM)
>  M:	Alasdair Kergon <agk@redhat.com>
> -M:	dm-devel@redhat.com
>  L:	dm-devel@redhat.com
>  W:	http://sources.redhat.com/dm
>  Q:	http://patchwork.kernel.org/project/dm-devel/list/

Is this part of some other changes to the definition of M and L?

Otherwise I don't agree with the change.

MAINTAINERS states:

        M: Mail patches to: FullName <address@domain>
        L: Mailing list that is relevant to this area

In the case of dm-devel, it's not merely a "relevant" list, but it is
essential for us: patches to dm must be sent to the list for patchwork
to collect.  I shall also add Mike Snitzer as a joint maintainer.

And did you notice this bit with uapi?
F:      include/linux/dm-*.h

Alasdair

