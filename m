Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3EMUVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 16:21:04 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:26875 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755286Ab3EMUVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 16:21:02 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX197WWS+r+948iZhNkFNcdEFEijvd9U7KgM=
Date: Mon, 13 May 2013 16:20:56 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: dove: add si5351 clock driver to CuBox DT
Message-ID: <20130513202056.GC31290@titan.lakedaemon.net>
References: <1367342675-15312-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367342675-15312-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 07:24:35PM +0200, Sebastian Hesselbarth wrote:
> This patch adds the device tree node for si5351 clock generator
> and the corresponding oscillator connected to it. It also limits
> i2c frequency to 100kHz as there are bus locks reported on higher
> frequencies.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/dove-cubox.dts |   51 +++++++++++++++++++++++++++++++++++++-
>  1 files changed, 50 insertions(+), 1 deletions(-)

Applied to mvebu/dt

thx,

Jason.
