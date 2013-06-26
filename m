Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab3FZDVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 23:21:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab3FZDVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 23:21:11 -0400
Date: Tue, 25 Jun 2013 23:20:27 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Hyunhee Kim <hyunhee.kim@samsung.com>
Cc: Kyungmin Park <kmpark@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, minchan@kernel.org,
        anton@enomsg.org, akpm@linux-foundation.org
Subject: Re: [PATCH] vmpressure: implement strict mode
Message-ID: <20130625232027.7c3ed3de@redhat.com>
In-Reply-To: <CAOK=xRN-cNJZgPqWuapsPjeGqFm9RAEXVn6kN971aZ016ocxxA@mail.gmail.com>
References: <20130625175129.7c0d79e1@redhat.com>
	<CAH9JG2U6Kg9MBdFX-OnfrqGAsJGJwEMkg01-uUycF1r3VyZqrg@mail.gmail.com>
	<CAOK=xRN-cNJZgPqWuapsPjeGqFm9RAEXVn6kN971aZ016ocxxA@mail.gmail.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013 10:12:15 +0900
Hyunhee Kim <hyunhee.kim@samsung.com> wrote:

> Please see "[PATCH v3] memcg: event control at vmpressure". mail
> thread. (and also the thread I sent last Saturday.)
> There was discussion on this mode not sending lower events when "level
> != ev->level".

The new argument this patch adds should be orthogonal to what has been
discussed and suggested in that thread. The patches conflict though, but
it's just a matter of rebasing if both are ACKed.
