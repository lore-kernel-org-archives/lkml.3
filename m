Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbbAVAVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 19:21:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:39093 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbbAVAVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 19:21:00 -0500
Message-ID: <f9cbb34c9228b2af7ed6c1c96a6aa61c.squirrel@www.codeaurora.org>
In-Reply-To: <1702448.pOVnDx4KzI@wuerfel>
References: <1420754626-30121-1-git-send-email-wstephen@codeaurora.org>
    <2318041.V2OJAPu7gC@wuerfel>
    <3ad19b16fe5c58612479f70c052d0045.squirrel@www.codeaurora.org>
    <1702448.pOVnDx4KzI@wuerfel>
Date: Thu, 22 Jan 2015 00:20:59 -0000
Subject: Re: [PATCH] ethernet: atheros: Add nss-gmac driver
From: wstephen@codeaurora.org
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: wstephen@codeaurora.org, jcliburn@gmail.com, grant.likely@linaro.org,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right. For review purposes, I think it would be helpful to split this
> huge patch into several steps then:
>
> - add a base driver
> - add the overlay interface
> - add the nss driver
>
> Ideally more of them.

The nss-drv driver is open sourced but we are currently not planning to
upstream to linux kernel yet because we are still actively adding new
features
https://www.codeaurora.org/cgit/quic/qsdk/oss/lklm/nss-drv

> Thanks for the description, this sounds very interesting indeed. I do
> have more questions though: how do you get the rules into the NSS driver?
> Does this get handled transparently by the openvswitch driver or
> did you have to add new user interfaces for it?
>
> 	Arnd
>

No, we are not using openvswitch. We have a connection manager monitoring
conntrack events and creates rules then send it through the interface
built in nss-drv.

Thanks,
Stephen

