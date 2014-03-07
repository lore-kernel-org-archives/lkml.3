Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaCGPoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:44:04 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42567 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753607AbaCGPoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:44:01 -0500
Date: Fri, 7 Mar 2014 10:44:00 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Laight <David.Laight@ACULAB.COM>
cc: "'Mathias Nyman'" <mathias.nyman@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        stable <stable@vger.kernel.org>
Subject: RE: [PATCH 1/2] Revert "xhci 1.0: Limit arbitrarily-aligned scatter
 gather."
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6D771D@AcuExch.aculab.com>
Message-ID: <Pine.LNX.4.44L0.1403071043020.1246-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2014, David Laight wrote:

> From: Mathias Nyman
> > This reverts commit 247bf557273dd775505fb9240d2d152f4f20d304.
> 
> You need to revert further.
> Just don’t set hcd->self.no_sg_constraint ever - since it just
> doesn't work.

No; it does work most of the time.

If hcd->self.no_sg_constraint wasn't sent, then certain commands would 
fail always, instead of failing occasionally.

Alan Stern

