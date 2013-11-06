Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab3KFSXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 13:23:17 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40392 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab3KFSXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:23:16 -0500
Message-ID: <1383762190.4291.183.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH v2 2/2] x86: add prefetching to do_csum
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Date: Wed, 06 Nov 2013 10:23:10 -0800
In-Reply-To: <20131106155445.GB6357@neilslaptop.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	 <1383751399-10298-1-git-send-email-nhorman@tuxdriver.com>
	 <1383751399-10298-3-git-send-email-nhorman@tuxdriver.com>
	 <20131106153429.GA26336@redhat.com>
	 <20131106155445.GB6357@neilslaptop.think-freely.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-06 at 10:54 -0500, Neil Horman wrote:

> My guess was that the whole comment was made in reference to the fact that
> checksum offload negated all these advantages.  Thats not so true anymore, since
> infiniband needs csum in software for ipoib.
> 
> I'll fix this up and send a v3, but I'll give it a day in case there are more
> comments first.

Also please include netdev, I think people there are interested.

I caught this message, but I usually cannot read lkml traffic.

I wonder why you do not use (and/or change/tune) prefetch_range()
instead of a local definition.



