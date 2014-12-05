Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaLEUM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 15:12:56 -0500
Received: from ida.rowland.org ([192.131.102.52]:50011 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1750779AbaLEUMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 15:12:49 -0500
Date: Fri, 5 Dec 2014 14:34:11 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@ida.rowland.org
To: Sanjay Singh Rawat <snjsrwt@gmail.com>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        <andrzej.p@samsung.com>, <mina86@mina86.com>
Subject: Re: [PATCH] usb: gadget: f_mass_storage: restore address range on
 exit
In-Reply-To: <1417778490-20723-1-git-send-email-snjsrwt@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1412051433360.13167-100000@ida.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2014, Sanjay Singh Rawat wrote:

> At the start of the thread we are changing the address limit, restoring it
> to the default while exiting.

What for?  The thread is about to exit anyway.  Who cares what the 
address limit is set to?

Alan Stern

