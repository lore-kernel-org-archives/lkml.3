Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab3C3A3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 20:29:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41410 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380Ab3C3A3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 20:29:53 -0400
Message-ID: <1364603383.16937.60.camel@smoke>
Subject: Re: [PATCH v3 4/7] USB: EHCI: export ehci_shutdown
From: Geoff Levand <geoff@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Arnd Bergmann <arnd@arndb.de>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Stephen Warren <swarren@nvidia.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        USB list <linux-usb@vger.kernel.org>,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Date: Fri, 29 Mar 2013 17:29:43 -0700
In-Reply-To: <Pine.LNX.4.44L0.1303291541460.1467-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1303291541460.1467-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> Actually, I think this is not necessary.  Instead those three glue
> files ought to be changed.  They should not need to call
> ehci_shutdown() directly.

I sent out a separate patch that removes the ehci_shutdown()
call in ps3_ehci_remove().  I tested it by removing and
installing the ehci_hcd module and it seems to work OK.

-Geoff

