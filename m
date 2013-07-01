Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab3GAOaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:30:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38400 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751252Ab3GAO37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:29:59 -0400
Date: Mon, 1 Jul 2013 10:29:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: ZhenHua <zhen-hual@hp.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] usb,uhci: add a new tag for virtual uhci devices
In-Reply-To: <51D0D73F.2060401@hp.com>
Message-ID: <Pine.LNX.4.44L0.1307011027070.1547-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013, ZhenHua wrote:

> Let's make it clear:
> I said "I don't have a machine that this makes action different",
> it does not mean my patch "did not make the machine act different ".

Of course.

> There are many kinds of machines, I have never said "my patch does
> not make ALL of them act different".

But does it make a difference on _any_ machine?

There is a good reason for asking this question.  The "auto-stopp"  
mechanism in uhci-hcd was intended to be a temporary measure.  It isn't
needed now that we have runtime PM.  Adding a patch just to make it 
work on a few systems doesn't seem worthwhile -- we would be better off 
removing it entirely.

Alan Stern


