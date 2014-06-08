Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaFHLO2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 07:14:28 -0400
Received: from ns.horizon.com ([71.41.210.147]:14128 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753481AbaFHLO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 07:14:27 -0400
Date: 8 Jun 2014 07:14:25 -0400
Message-ID: <20140608111425.3897.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dborkman@redhat.com, linux@horizon.com
Subject: Re: [PATCH 7/7] lib/random32.c: Remove redundant U suffixes on integers
Cc: davem@davemloft.net, hannes@stressinduktion.org,
        linux-kernel@vger.kernel.org, shemminger@osdl.org, tytso@mit.edu
In-Reply-To: <53943C95.4060200@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [ Please also Cc Hannes in your series. ]

Thank you!  But there are two frequent kernel contributors with that name;
the other is Hannes Reinecke <hare@suse.de>.

> I don't see the point in why we _need_ to change this here.

We don't.  It was just a slight legibility improvement (at least, *I*
find it more legible) included as long as I was working in the area.
But split out to avoid making review of the substantive parts any
more difficult, and so it can be dropped easily if there are objections.

We tend to avoid cosmetic cleanups if there is not other work to
do in an area, so I assume that if there *is* other work to do in
an area, cosmetic cleanups are okay.
