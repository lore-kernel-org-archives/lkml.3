Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844AbaE3KAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 06:00:24 -0400
Received: from smtp1.ngi.it ([88.149.128.112]:44074 "EHLO smtp1.ngi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303AbaE3KAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 06:00:22 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 May 2014 06:00:21 EDT
Message-ID: <7EC4C3FDEFF6492F91DEE16AEE0831E6@vanni.it>
From: "Valerio Vanni" <valerio.vanni@inwind.it>
To: <linux-pm@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>, <baryluk@smp.if.uj.edu.pl>,
        <davem@davemloft.net>, <peter@hurleysoftware.com>, <rjw@rjwysocki.net>,
        <aaron.lu@intel.com>, <tianyu.lan@intel.com>
Subject: Re: serial console does not wake from S3 suspend
Date: Fri, 30 May 2014 11:53:14 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When resuming from S3 suspend, serial console starts sending garbage
> on the serial port.
> Not continuously, it sends garbage only when in local console prints a
> text.
> It stops only when the (sending) machine is shut down, or if some
> text is sent manually (i.e. with "cat txtfile > /dev/ttyS0").
> 
> Full details are here:
> https://bugzilla.kernel.org/show_bug.cgi?id=69751

The problem is still present in 3.14.4, 3.15-rc7 and today's next.

I hope someone is going to look at this bug.

