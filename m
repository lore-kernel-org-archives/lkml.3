Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472Ab3CVObT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:31:19 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:37036 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933003Ab3CVObR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:31:17 -0400
Message-ID: <514C6B2D.5000100@openwrt.org>
Date: Fri, 22 Mar 2013 15:31:09 +0100
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: davem@davemloft.net, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4 v3] mv643xx_eth: use mvmdio MDIO bus driver
References: <1363284515-9865-1-git-send-email-florian@openwrt.org> <1363959568-16976-1-git-send-email-florian@openwrt.org> <20130322141423.GJ13280@titan.lakedaemon.net> <514C69B7.8090106@openwrt.org> <20130322142924.GK13280@titan.lakedaemon.net>
In-Reply-To: <20130322142924.GK13280@titan.lakedaemon.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 03/22/13 15:29, Jason Cooper a écrit :
>> Ok, thanks! Does that mean that you want these changes to go via
>> your tree? David initially applied my v2 of this patchset, and since
>> it thouches mostly ethernet driver stuff, I would rather make it go
>> via his tree if both of you agree.
>
> Yeah, I thought I should have reworded that after I hit send :)  I
> simply meant it applied cleanly against v3.9-rc3, booted, and worked.  I
> Acked it so David could take the whole series through his tree.  Sorry
> for the confusion.
>
> Now that I can build mv643xx_eth DT on top of this, I'll structure it so
> those changes go on top of yours (in David's tree) and try to avoid the
> external dependency for the DT bits going though arm-soc.

Sounds good! FYI, I am finishing up DSA Device Tree bindings so that we 
can finally get rid of board-specific Kirkwood files.
--
Florian
