Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292Ab3DYO43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:56:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60486 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757413Ab3DYO42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:56:28 -0400
Date: Thu, 25 Apr 2013 10:56:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: ZhenHua <zhen-hual@hp.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tom.vaden@hp.com>
Subject: Re: [PATCH 1/1] driver,usb: Fix a warning in uhci-hcd driver
In-Reply-To: <Pine.LNX.4.44L0.1304251032460.1185-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1304251055520.1185-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Alan Stern wrote:

> On Thu, 25 Apr 2013, ZhenHua wrote:
> 
> > I send out this patch for the second time.
> > Changed try to int. And modified the comment.
> 
> You did not answer my question: How long does it take for the iLo 
> controller to go into suspend?

Oops, sorry, I see now that you did answer the question in a different
email message.

Alan Stern

