Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaESUDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:03:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42883 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751117AbaESUDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:03:43 -0400
Date: Mon, 19 May 2014 16:03:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
cc: "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        Amit Uttamchandani <auttamchandani@logicube.com>
Subject: Re: [PATCH 2/5] usb: gadget: net2280: Use S_I macros
In-Reply-To: <CAPybu_3hnb+_V5kkzxaYFtc4GeKCs84VzPRVbAhJbfqO57tcsA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1405191602370.1538-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014, Ricardo Ribalda Delgado wrote:

> Hello Alan
> 
> What about using octal notation in all the file and merge the patch
> with the other big patch of the series? I am trying to have some
> consistency in the file :)

Program files don't have to be consistent.  You shouldn't waste energy 
just on that.  It would be a lot better to spend your time fixing bugs 
or helping other people solve problems.

Alan Stern

