Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab3FZHur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:50:47 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:43963 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3FZHur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:50:47 -0400
X-AuditID: 9c93017d-b7c09ae000006fa0-c8-51ca9d55481b
Date: Wed, 26 Jun 2013 16:50:51 +0900
From: Minchan Kim <minchan@kernel.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mhocko@suse.cz,
        anton@enomsg.org, akpm@linux-foundation.org
Subject: Re: [PATCH] vmpressure: implement strict mode
Message-ID: <20130626075051.GG29127@bbox>
References: <20130625175129.7c0d79e1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625175129.7c0d79e1@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 05:51:29PM -0400, Luiz Capitulino wrote:
> Currently, applications are notified for the level they registered for
> _plus_ higher levels.
> 
> This is a problem if the application wants to implement different
> actions for different levels. For example, an application might want
> to release 10% of its cache on level low, 50% on medium and 100% on
> critical. To do this, the application has to register a different fd
> for each event. However, fd low is always going to be notified and
> and all fds are going to be notified on level critical.
> 
> Strict mode solves this problem by strictly notifiying the event
> an fd has registered for. It's optional. By default we still notify
> on higher levels.
> 
> Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Acked-by: Minchan Kim <minchan@kernel.org>

Shouldn't we make this default?
What do you think about it?

-- 
Kind regards,
Minchan Kim
