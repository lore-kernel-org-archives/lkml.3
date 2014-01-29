Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaA2Wjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 17:39:44 -0500
Received: from vps1.hno.se ([31.192.227.87]:37367 "EHLO vps1.hno.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbaA2Wjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 17:39:43 -0500
Message-ID: <1391035079.14902.3.camel@localhost>
Subject: Re: [linux-sunxi] Re: [RFC PATCH v2 09/14] mtd: nand: add sunxi NFC
 dt bindings doc
From: Henrik =?ISO-8859-1?Q?Nordstr=F6m?= <henrik@henriknordstrom.net>
To: linux-sunxi@googlegroups.com
Cc: Boris BREZILLON <b.brezillon.dev@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mtd@lists.infradead.org, dev@linux-sunxi.org
Date: Wed, 29 Jan 2014 23:37:59 +0100
In-Reply-To: <CAL_JsqLVr1gSLArqtfOiHce+u6ZK8FiKMX0o9bvMrMoGGhATvg@mail.gmail.com>
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
	 <1391006064-28890-10-git-send-email-b.brezillon.dev@gmail.com>
	 <CAL_JsqLVr1gSLArqtfOiHce+u6ZK8FiKMX0o9bvMrMoGGhATvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ons 2014-01-29 klockan 11:11 -0600 skrev Rob Herring:

> Isn't allwinner,rb implied by a lack of rb-gpios property. Or no R/B
> pin is an option? If so, don't you need some fixed time delay
> properties like max erase time?
> 
> rb-gpios could be added to the generic nand binding as well.

The Allwinner NAND controller have dedicated RB pins when NAND is
enabled, only MUXed with other functions when NAND is not enabled.

Leaving RB unconnected is not a valid hardware configuration. The
controller internal timing engine depends on being able to sense RB to
sequence NAND commands properly.

Regards
Henrik

