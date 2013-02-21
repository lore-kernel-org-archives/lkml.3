Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab3BUSCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:02:35 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60874 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab3BUSCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:02:34 -0500
Date: Thu, 21 Feb 2013 13:02:32 -0500 (EST)
Message-Id: <20130221.130232.875234888321258862.davem@davemloft.net>
To: lee.roberts@hp.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4 v2] sctp: fix association hangs due to off-by-one
 errors in sctp_tsnmap_grow()
From: David Miller <davem@davemloft.net>
In-Reply-To: <D64EC45690EF85409BA6C4730E0162244310DF62@G4W3231.americas.hpqcorp.net>
References: <D64EC45690EF85409BA6C4730E0162244310DF62@G4W3231.americas.hpqcorp.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 21 Feb 2013 10:02:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Roberts, Lee A." <lee.roberts@hp.com>
Date: Thu, 21 Feb 2013 17:57:46 +0000


When you are given feedback on patches you submit, you should wait
some time for all the feedback to settle, then resubmit your entire
series (not just the patches that needed changes).

> Patch applies to linux-3.8 kernel.

This is not appropriate to mention in a commit message, your patches
might get ported to -stable trees and elsewhere, and such a comment
looks awkward at best in such scenerios.
