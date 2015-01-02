Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbbABOFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 09:05:40 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:35287 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbbABOFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 09:05:38 -0500
Date: Fri, 2 Jan 2015 15:05:32 +0100
From: Johan Hovold <johan@kernel.org>
To: Richard <richjunk@pacbell.net>
Cc: Johan Hovold <johan@kernel.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: Kernel 3.17.x Attaching Keyspan 4-Port Serial to USB Adapter
 Causes Kernel Panic
Message-ID: <20150102140532.GA12611@localhost>
References: <54960F74.1050608@pacbell.net>
 <20141222175301.GF30375@localhost>
 <5499D72C.7090502@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5499D72C.7090502@pacbell.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 12:57:16PM -0800, Richard wrote:

> > This driver is a bit of a mess.  Could you try the patch below and
> > see if it fixes the problem?
> 
> Yes.  Thank you.  That fixes the issue.  I can now plug in the Keyspan
> USB adapter to my new running system without the kernel freezing.  I
> applied your patch to 3.17.7.   I have not yet tried it on 3.18.1.
> 
> Using minicom I tested the usb-serial devices and everything seems to
> work.

Great, thanks for testing.

Johan
