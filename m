Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab3FZTRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:17:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60087 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752023Ab3FZTRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:17:17 -0400
Date: Wed, 26 Jun 2013 15:17:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] usb,uhci: add a new tag for virtual uhci devices
In-Reply-To: <1372228185-11518-1-git-send-email-zhen-hual@hp.com>
Message-ID: <Pine.LNX.4.44L0.1306261516280.1880-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013, Li, Zhen-Hua wrote:

> From: "Li, Zhen-Hua" <zhen-hual@hp.com>
> 
> There's another patch trying to fix this warning:
>  "Controller not stopped yet!". 
> It is : 997ff893603c6455da4c5e26ba1d0f81adfecdfc .
> 
> I don't think it is appropriate to avoid auto-stop for all HP uhci
> devices. So add one  tag for the virtual uhci devices, it is used
> to replace "wait_for_hp" in the auto-stop case.

Do you have any machines where this makes a difference?

Alan Stern

