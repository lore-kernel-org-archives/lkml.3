Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965110AbaFCUPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:15:48 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:60339 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932917AbaFCUPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:15:46 -0400
Message-ID: <1401826536.4157.54.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC 0/4 v2] cfg80211/mac80211: Add new interface type for OCB
 (Outside the Context of a BSS) mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Tue, 03 Jun 2014 22:15:36 +0200
In-Reply-To: <1401468984-24575-1-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140530_185636_416967_38B72FDB)
References: <1401468984-24575-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140530_185636_416967_38B72FDB)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-30 at 18:56 +0200, Rostislav Lisovy wrote:

> This patchset presents work in progress. Patches adding *_leave_ocb()
> functions and modifying RX/TX path in mac80211 to work with OCB
> mode will come in near future.

Oh, sorry - I commented on that but failed to read the cover letter
first. My bad.

Overall you're off on a good start I think - see the comments I had on
the patches.

I'm hoping that drivers implementing this won't actually need any
station entries. Apart from that, it's unclear to me how the bitrate is
selected, are there even different bitrates?

johannes

