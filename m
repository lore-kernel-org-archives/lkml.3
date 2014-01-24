Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaAXNl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:41:27 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:36990 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaAXNlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:41:24 -0500
Date: Fri, 24 Jan 2014 07:38:31 -0600
From: Andrew Ruder <andy@aeruder.net>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: sk == 0xffffffff fix - not for commit
Message-ID: <20140124133831.GB20804@gmail.com>
Mail-Followup-To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Felipe Balbi <balbi@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Nazarewicz <mina86@mina86.com>,
	"David S. Miller" <davem@davemloft.net>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	James Morris <jmorris@namei.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
References: <1386589672-5830-1-git-send-email-andrzej.p@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386589672-5830-1-git-send-email-andrzej.p@samsung.com>
User-Agent: Mutt/1.5.21+155 (d3096e8796e7) (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually found what looks to be a fix for this in another thread.

http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg574770.html
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58854

Cheers,
Andy
