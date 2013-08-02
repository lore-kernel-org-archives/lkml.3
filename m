Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab3HBDuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 23:50:14 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44472 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754853Ab3HBDuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 23:50:12 -0400
Message-ID: <1375415410.2034.100.camel@joe-AO722>
Subject: Re: [PATCH] MAINTAINERS: Add separate section for USB NETWORKING
 DRIVERS
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-usb <linux-usb@vger.kernel.org>
Date: Thu, 01 Aug 2013 20:50:10 -0700
In-Reply-To: <20130802033033.GA2658@kroah.com>
References: <1375316960686@kroah.org> <1375343328.2034.34.camel@joe-AO722>
	 <20130801075656.GA8074@kroah.com> <1375344595.2034.38.camel@joe-AO722>
	 <20130802033033.GA2658@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 11:30 +0800, Greg KH wrote:
> On Thu, Aug 01, 2013 at 01:09:55AM -0700, Joe Perches wrote:
> > Lots of "maintainers" don't apply patches.
> I have no idea what you are meaning here.

Just that maintainers aren't necessarily appliers.
In fact, most aren't.

> Add netdev to the L: list as well.

I don't think it's necessary.
get_maintainers already shows that via the
NETWORKING DRIVERS section F: drivers/net/

Maybe adding
	W:	http://www.linux-usb.org/usbnet
might be useful, but it seems pretty out of date.

btw: This is a similar section to what I suggested.
     No named "maintainer"

NETWORKING DRIVERS
L:	netdev@vger.kernel.org
W:	http://www.linuxfoundation.org/en/Net
Q:	http://patchwork.ozlabs.org/project/netdev/list/
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
S:	Odd Fixes
F:	drivers/net/


