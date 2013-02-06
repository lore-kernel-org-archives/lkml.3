Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab3BFPqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:46:25 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41205 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753765Ab3BFPqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:46:23 -0500
Date: Wed, 6 Feb 2013 10:46:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Yuan-Hsin Chen <yuanlmm@gmail.com>
cc: gregkh@linuxfoundation.org, <sarah.a.sharp@linux.intel.com>,
        <balbi@ti.com>, <Julia.Lawall@lip6.fr>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>
Subject: Re: [PATCH] usb host: Faraday FUSBH200 HCD driver.
In-Reply-To: <1360149841-2392-1-git-send-email-yuanlmm@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1302061045240.1893-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2013, Yuan-Hsin Chen wrote:

> From: Yuan-Hsin Chen <yhchen@faraday-tech.com>
> 
> USB2.0 HCD driver for Faraday FUSBH200

In what way is this driver different from the existing ehci-hcd driver?  
It looks like almost all of the code is identical.  We don't need to 
have two copies of the same code in the kernel.

Alan Stern

