Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaFJQna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:43:30 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:56143 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbaFJQn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:43:27 -0400
Message-ID: <1402418588.4152.0.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC 0/4 v2] cfg80211/mac80211: Add new interface type for OCB
 (Outside the Context of a BSS) mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Tue, 10 Jun 2014 18:43:08 +0200
In-Reply-To: <1402322954.11505.10.camel@umadbro> (sfid-20140609_160917_275820_58731C2F)
References: <1401468984-24575-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140530_185636_416967_38B72FDB) <1401826536.4157.54.camel@jlt4.sipsolutions.net>
	 <1402322954.11505.10.camel@umadbro> (sfid-20140609_160917_275820_58731C2F)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-09 at 16:09 +0200, Rostislav Lisovy wrote:
> On Tue, 2014-06-03 at 22:15 +0200, Johannes Berg wrote:
> > it's unclear to me how the bitrate is
> > selected, are there even different bitrates?
> 
> My understanding is that since we are using OFDM we have to support at
> least 3, 6, 12 Mb/s data rates (says 802.11-2012, Chapter 18.1.1, second
> paragraph). How to choose it when transmitting? That should probably be
> defined in some standard built on top of "802.11p" -- the European
> "Intelligent Transport System" standard ETSI EN 302 663 defines
> different channels in 5.9 Ghz band along with the "default data
> rate" (Table 2, Chapter 4.3). For example Control Channel (nr. 180) has
> data rate 6 Mb/s, while Service Channel 2 (nr. 178) has data rate 12
> Mb/s.

But that probably means then that you have to select the rate in the
join command.

johannes

