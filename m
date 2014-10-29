Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934427AbaJ2QEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:04:53 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:38791 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933724AbaJ2QEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:04:51 -0400
Message-ID: <1414598676.1827.26.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 1/1 net-next] cfg80211: fix set but not used warning in
 nl80211_channel_switch()
From: Johannes Berg <johannes@sipsolutions.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 29 Oct 2014 17:04:36 +0100
In-Reply-To: <1414252655-20506-1-git-send-email-fabf@skynet.be>
References: <1414252655-20506-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-25 at 17:57 +0200, Fabian Frederick wrote:
> radar_detect_width is unused since commit 97dc94f1d933
> ("cfg80211: remove channel_switch combination check")

Applied, thanks.

johannes

