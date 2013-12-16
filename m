Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab3LPStV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:49:21 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55201 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab3LPStT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:49:19 -0500
Date: Mon, 16 Dec 2013 18:48:58 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Schichan <nschichan@freebox.fr>
Cc: Leigh Brown <leigh@solinno.co.uk>, Jason Cooper <jason@lakedaemon.net>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <florian@openwrt.org>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: Spurious timeouts in mvmdio
Message-ID: <20131216184858.GR4360@n2100.arm.linux.org.uk>
References: <529CA42A.3040504@freebox.fr> <20131203122346.GD29282@titan.lakedaemon.net> <20131203124033.GT16735@n2100.arm.linux.org.uk> <abe249f5cba5c267e2c536bd62c57908@doppler.thel33t.co.uk> <529E5F03.8040607@gmail.com> <8d65780eb7bfe49bb0734a09f05f70a6@doppler.thel33t.co.uk> <529E66A4.4050000@gmail.com> <ae69666fd3b61411d7bbd9ac993cec13@doppler.thel33t.co.uk> <20131203234209.GW16735@n2100.arm.linux.org.uk> <52AF4160.9080703@freebox.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AF4160.9080703@freebox.fr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 07:07:28PM +0100, Nicolas Schichan wrote:
> I did not find any commit for this in 3.13-rc4.
>
> Would you prefer I submit my attempt at refactoring the  
> orion_mdio_wait_ready() code ?

It's up to Jason.
