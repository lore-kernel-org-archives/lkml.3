Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaJVGgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:36:32 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:49048 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbaJVGgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:36:17 -0400
Message-ID: <1413959764.1958.0.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 1/1 net-next] mac80211: remove unnecessary null test
 before debugfs_remove
From: Johannes Berg <johannes@sipsolutions.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 22 Oct 2014 08:36:04 +0200
In-Reply-To: <1473755457.212484.1413921941002.open-xchange@webmail.nmp.skynet.be>
References: <1413908412-5177-1-git-send-email-fabf@skynet.be>
	 <1413918366.1998.10.camel@jlt4.sipsolutions.net>
	 <1473755457.212484.1413921941002.open-xchange@webmail.nmp.skynet.be>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 22:05 +0200, Fabian Frederick wrote:

> I can also resubmit patch if necessary.

No worries, I've already applied the patch (with a modified commit
message).

johannes

