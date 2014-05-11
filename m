Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbaEKMtz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 08:49:55 -0400
Received: from mail0.toppoint.de ([217.70.197.20]:55229 "EHLO
	mail0.toppoint.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758002AbaEKMtx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 08:49:53 -0400
Date: Sun, 11 May 2014 12:46:34 +0000
From: Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>
To: Anish Khurana <anish.khurana130181@gmail.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-rdma@vger.kernel.org,
        linux-acenic@sunsite.dk, nios2-dev@lists.rocketboards.org,
        linuxppc-dev@lists.ozlabs.org, e1000-devel@lists.sourceforge.net,
        devel@linuxdriverproject.org, linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-wireless@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
        b.a.t.m.a.n@lists.open-mesh.org, bridge@lists.linux-foundation.org,
        dev@openvswitch.org, trivial@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [resend] net: get rid of SET_ETHTOOL_OPS
Message-ID: <20140511124633.GD7875@kaos.lebenslange-mailadresse.de>
Mail-Followup-To: Anish Khurana <anish.khurana130181@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>, linux-rdma@vger.kernel.org,
	linux-acenic@sunsite.dk, nios2-dev@lists.rocketboards.org,
	linuxppc-dev@lists.ozlabs.org, e1000-devel@lists.sourceforge.net,
	devel@linuxdriverproject.org, linux-usb@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
	b.a.t.m.a.n@lists.open-mesh.org, bridge@lists.linux-foundation.org,
	dev@openvswitch.org, trivial@kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20140511001231.GC7875@kaos.lebenslange-mailadresse.de>
 <CANKiNjV7qrx-556DJk0qcOopnBs4NnKy51POEeZ7LpbdjX35OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CANKiNjV7qrx-556DJk0qcOopnBs4NnKy51POEeZ7LpbdjX35OQ@mail.gmail.com>
X-message-flag: Get yourself a real email client. http://www.mutt.org/
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sun, May 11, 2014 at 01:13:47PM +0530 schrieb Anish Khurana:
> SET_ETHTOOL_OPS is equivalent to :
> #define SET_ETHTOOL_OPS(netdev,ops) \
>     ( (netdev)->ethtool_ops = (ops) )
> 
> how it makes difference  removing this code and replacing with the
> code mentioned ?

It doesn't change anything in the resulting binaries. The whole point
is to remove the macro, which is something Dave wants to happen.

Kind regards,
Wilfried

