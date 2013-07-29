Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3G2Idh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 04:33:37 -0400
Received: from etezian.org ([198.101.225.253]:59153 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab3G2Idf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 04:33:35 -0400
Date: Mon, 29 Jul 2013 10:33:25 +0200
From: Andi Shyti <andi@etezian.org>
To: Steve French <smfrench@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org,
        Andi Shyti <andi@etezian.org>, mikko.rapeli@iki.fi
Subject: Re: [PATCH 2/2] cifs: file: initialize oparms.reconnect before using
 it
Message-ID: <20130729083325.GA1948@jack.whiskey>
References: <CAH2r5msP8+qZnb38Rj5WMWmqWFtopmoe671G6TNTB=61BvYEnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5msP8+qZnb38Rj5WMWmqWFtopmoe671G6TNTB=61BvYEnA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

> Your patch looks reasonable.   Would you repost the patch to
> linux-cifs mailing list (and add any additional reviewers or testers
> if you would like if you got feedback)?

Thanks for your mail,

Actually linux-cifs is on CC and this is the output of
get_maintainer:

Steve French <sfrench@samba.org> (supporter:COMMON INTERNET F...)
linux-cifs@vger.kernel.org (open list:COMMON INTERNET F...)
samba-technical@lists.samba.org (moderated list:COMMON INTERNET F...)
linux-kernel@vger.kernel.org (open list)

All are on CC. get_maintainers, indeed sometimes is not very
precise since gets the CC list by doing a git blame on the file
and adding the ones who previously modified the specific lines.

If this patch got lost I could enrich my To/Cc list by looking at
git shortlog and more carefully at git blame.

Thanks,
Andi
