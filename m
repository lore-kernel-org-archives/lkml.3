Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab3AVIXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 03:23:50 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40684 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751867Ab3AVIXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 03:23:48 -0500
X-Sasl-enc: MGqE5AQbtFXjOzFI4VWYMaJ1Ik2njXom6yYYrHdHYAG5 1358843028
Message-ID: <50FE4C92.3060103@imap.cc>
Date: Tue, 22 Jan 2013 09:23:46 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: isdn@linux-pingi.de, hjlipp@web.de, keil@b1-systems.de,
        i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] ISDN patches for net-next
References: <20130121-patch-isdn-00.tilman@imap.cc> <20130121.173810.2229077237480842007.davem@davemloft.net>
In-Reply-To: <20130121.173810.2229077237480842007.davem@davemloft.net>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.01.2013 23:38, schrieb David Miller:
> Patches 1-5 applied to net-next, patch 6 applied to 'net' and queued
> up for -stable.

Thanks.

> We don't have changes bypass 'net' and go into stable from net-next
> like you intended.  We also don't use CC: stable for networking
> patches, you ask me to queue them up into my -stable patch queue
> for networking instead.

I see. Is there somewhere I can read up on the workflow for networking
patches and how it fits in with the general plan of things?

Thanks,
Tilman

-- 
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)


