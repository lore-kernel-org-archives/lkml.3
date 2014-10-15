Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaJOO4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:56:22 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:38976 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbaJOO4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:56:20 -0400
Date: Wed, 15 Oct 2014 16:55:39 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Benoit Masson <benoitm@perenite.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benoit Masson <yahoo@perenite.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] Armada XP pinctrl consolidation and ix4-300d fixes
Message-ID: <20141015145539.GB18413@lunn.ch>
References: <-7443282711873112734@unknownmsgid>
 <20141003141102.GJ3895@titan.lakedaemon.net>
 <542EBB93.108@gmail.com>
 <A9781A2E-F3CA-4E8A-833C-D167B456D9F7@perenite.com>
 <542EC3A3.1060605@gmail.com>
 <1ACB5318-863E-40D8-8B27-41F1C0D0A4B8@perenite.com>
 <5432BFB1.2060300@gmail.com>
 <CE7A9795-C2AF-451A-8018-3A0B8788BF60@perenite.com>
 <20141015144259.GB17447@titan.lakedaemon.net>
 <543E898D.10606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543E898D.10606@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >Do you have a link to an email thread or the patch Subject line?  I can
> >confirm it's missing from mvebu/fixes...
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/275487.html
> 
> But you and Andrew should check what Arnd suggested. IIRC, there
> was also an appropriate follow-up patch discussion started by
> Andrew.

There was a lot of back and forth with Arnd. In the end, he gave up
arguing because too many voices did not like his solution. So my
original version stands.

However, the patch at the end of 

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/275528.html

is useful, and it would be nice if it could be merged as well.

   Andrew
