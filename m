Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaFHMmO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 08:42:14 -0400
Received: from ns.horizon.com ([71.41.210.147]:61743 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753472AbaFHMmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 08:42:13 -0400
Date: 8 Jun 2014 08:42:12 -0400
Message-ID: <20140608124212.2653.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dborkman@redhat.com, linux@horizon.com
Subject: Re: [PATCH 6/7] lib/random32.c: Randomize timeout to the millisecond, not the second
Cc: davem@davemloft.net, hannes@stressinduktion.org,
        linux-kernel@vger.kernel.org, shemminger@osdl.org, tytso@mit.edu
In-Reply-To: <539456DD.4020601@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Note, when you talk about efficiency here, this is called once every
> 40+ secs ... ;)

Agreed, in this case the code size saving (avoid a function call) is the
main benefit.  And I prefer to avoid inefficiency on general priinciples,
if it's not serving some other goal.
