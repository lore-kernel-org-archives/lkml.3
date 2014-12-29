Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaL2Sb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 13:31:58 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48769 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbaL2Sb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 13:31:56 -0500
Date: Mon, 29 Dec 2014 10:31:50 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: nick <xerofoify@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Vendor Setup for  walkera_dev structure argument in the
 function,walkera0701_connect for the file,walera0701.c
Message-ID: <20141229183150.GD9565@dtor-ws>
References: <54A0E57E.7000001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A0E57E.7000001@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Mon, Dec 29, 2014 at 12:24:14AM -0500, nick wrote:
> Greetings Dmirty,
> I am wondering about the below code in the function,walkera701_connect in the file,walera0701.c.
> /* TODO what id vendor/product/version ? */
>          w->input_dev->id.vendor = 0x0001;
>          w->input_dev->id.product = 0x0001;
>          w->input_dev->id.version = 0x0100;
> As the maintainer I am wondering if you known the values these need to
> be set to as it seems a rather trivial patch for me to write if you
> can send me the correct values or a reference sheet.

I think we should not have initialized them at all as I don't think we
have good values for IDs for it. But now that we had done that, current
values are as good as any... Just leave the driver alone.

Also, as you mentioned, producing a patch is trivial. If you want to get
involved in kernel development you need to do some research and actually
_propose_ the changes (with explanation why the change is needed and why
you chose to make the change in a certain way), rather just asking
maintainers for explicit instructions on what changes to make.

Thanks.

-- 
Dmitry
