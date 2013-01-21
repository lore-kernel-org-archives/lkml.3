Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab3AUWiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:38:14 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43785 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3AUWiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:38:13 -0500
Date: Mon, 21 Jan 2013 17:38:10 -0500 (EST)
Message-Id: <20130121.173810.2229077237480842007.davem@davemloft.net>
To: tilman@imap.cc
Cc: isdn@linux-pingi.de, hjlipp@web.de, keil@b1-systems.de,
        i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] ISDN patches for net-next
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130121-patch-isdn-00.tilman@imap.cc>
References: <20130121-patch-isdn-00.tilman@imap.cc>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Mon, 21 Jan 2013 22:57:20 +0100 (CET)

> here's a series of six patches to the ISDN subsystem. Please consider
> for application to net-next. The last one should also go into -stable
> and is tagged "CC: stable" accordingly.

Patches 1-5 applied to net-next, patch 6 applied to 'net' and queued
up for -stable.

We don't have changes bypass 'net' and go into stable from net-next
like you intended.  We also don't use CC: stable for networking
patches, you ask me to queue them up into my -stable patch queue
for networking instead.

Thanks.
