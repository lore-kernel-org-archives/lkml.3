Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3A2UpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 15:45:04 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60065 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab3A2UpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 15:45:01 -0500
Date: Tue, 29 Jan 2013 15:45:00 -0500 (EST)
Message-Id: <20130129.154500.1135013581072988248.davem@davemloft.net>
To: mst@redhat.com
Cc: jasowang@redhat.com, toralf.foerster@gmx.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] tun: fix carrier on/off status
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130128103801.GA6648@redhat.com>
References: <3592886.xagLc7Uij9@jason-thinkpad-t430s>
	<20130128101111.GB5337@redhat.com>
	<20130128103801.GA6648@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 28 Jan 2013 12:38:02 +0200

> Commit c8d68e6be1c3b242f1c598595830890b65cea64a removed carrier off call
> from tun_detach since it's now called on queue disable and not only on
> tun close.  This confuses userspace which used this flag to detect a
> free tun. To fix, put this back but under if (clean).
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied.
