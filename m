Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbaGIOlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:41:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49111 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751300AbaGIOlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:41:51 -0400
Date: Wed, 9 Jul 2014 10:41:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <Peter.Chen@freescale.com>,
        <kishon@ti.com>, <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] usb: add support to the PHY framework for HCD
In-Reply-To: <1404901036-27682-4-git-send-email-antoine.tenart@free-electrons.com>
Message-ID: <Pine.LNX.4.44L0.1407091035570.873-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2014, Antoine Ténart wrote:

> This patch adds the support to PHY framework in HCD code while keeping
> the USB PHY compatibility. Changes are done in both the HCD common code
> and in the drivers accessing its PHY. This is done in two steps:
> renaming 'phy' into 'usb_phy' and adding a new 'phy' member into the
> usb_hcd structure.

Can you split the two steps into two separate patches?  It will make 
them easier to review.

Alan Stern

