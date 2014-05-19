Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbaESURK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:17:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42903 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932511AbaESURJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:17:09 -0400
Date: Mon, 19 May 2014 16:17:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
cc: "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        Amit Uttamchandani <auttamchandani@logicube.com>
Subject: Re: [PATCH 5/5] usb: gadget: net2280: Use pr_* function
In-Reply-To: <CAPybu_1LLg4LEPdS2iN0qY=AYJmCiJOr6EhpR9Kn0Rn2H2dpOg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1405191615451.1538-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014, Ricardo Ribalda Delgado wrote:

> Hello Alan
> 
> I really think that setting/unsetting DEBUG and VERBOSE is not a good
> idea, and the generic functions are there to be used.

You could change the definitions of DEBUG and VDEBUG to make them use 
the generic functions.

> What do you think that makes it more difficult to read? The GETDEV macro?

Exactly.

Alan Stern

