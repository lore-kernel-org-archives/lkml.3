Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161855AbaKNUuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:50:32 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:53583 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbaKNUub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:50:31 -0500
Message-ID: <1415998228.1847.3.camel@sipsolutions.net>
Subject: Re: [PATCH v3 00/21] backports: add kernel integration support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: backports@vger.kernel.org, linux-kernel@vger.kernel.org,
        yann.morin.1998@free.fr, mmarek@suse.cz, sassmann@kpanic.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Fri, 14 Nov 2014 21:50:28 +0100
In-Reply-To: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20141111_091522_244502_9EA6DBD4)
References: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20141111_091522_244502_9EA6DBD4)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 00:14 -0800, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> This third series should hopefully address all pending feedback.
> I've split out patches even more, but more importantly have
> made the parser simpler by both integrating the logic required
> to understand a backport by identifying the backport by type
> and strategy, sharing that, and then providing ignore lists on
> the parsers.

I think from a code change POV I should be OK with this, but I'll
definitely want to run it and see the differences. I'll have to do that
next week, it's getting late here.

johannes

