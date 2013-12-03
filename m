Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3LCNe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:34:59 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43905 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab3LCNe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:34:57 -0500
Date: Tue, 3 Dec 2013 13:34:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Schichan <nschichan@freebox.fr>
Cc: linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        "David S. Miller" <davem@davemloft.net>,
        Leigh Brown <leigh@solinno.co.uk>,
        Florian Fainelli <florian@openwrt.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] net: mvmdio: fix wait_event_timeout() being called
	with a 1 jiffy timeout.
Message-ID: <20131203133412.GU16735@n2100.arm.linux.org.uk>
References: <20131203122346.GD29282@titan.lakedaemon.net> <1386076560-1886-1-git-send-email-nschichan@freebox.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386076560-1886-1-git-send-email-nschichan@freebox.fr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 02:16:00PM +0100, Nicolas Schichan wrote:
> If a timer interrupt kicks right after the wait_event_timeout() call,
> we may endup a reporting timeout before the timeout really occured.

Please see my reply to Jason Cooper about this in the thread
"Spurious timeouts in mvmdio".
