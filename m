Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab3AVQhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:37:03 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:51661 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab3AVQg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:36:58 -0500
Date: Tue, 22 Jan 2013 08:36:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Priyaranjan Das <priyaranjan456789@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Query related to MSR(Magnetic Stripe Reader) Device Driver
Message-ID: <20130122163655.GA21090@kroah.com>
References: <CAMNxYswRsYtRF3kXKR676TZMCUsZPvk0auYTxpGVS2mRLmS8xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMNxYswRsYtRF3kXKR676TZMCUsZPvk0auYTxpGVS2mRLmS8xw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 03:02:32PM +0530, Priyaranjan Das wrote:
> Hi All,
> 
> I am working on MSR(Magnetic Stripe Reader) for a product . I wish to
> know whether any MSR( Magnetic Stripe/card Reader) driver is available
> in the current source or not. I need this for reference. Could anyone
> please help me?

Most of these types of devices that I have worked with always show up as
a keyboard device (ps/2 pass-through or a USB hid device.)  What type of
interface does your device present to the operating system?

thanks,

greg k-h
