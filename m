Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab3IYXgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:36:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab3IYXgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:36:40 -0400
Date: Wed, 25 Sep 2013 16:36:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dominik Paulus <dominik.paulus@fau.de>
Cc: linux-kernel@vger.kernel.org,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>, linux-kernel@i4.cs.fau.de,
        devel@driverdev.osuosl.org
Subject: Re: [PATCHv2 0/11] staging: usbip: Userland crypto and ACLs
Message-ID: <20130925233638.GA21396@kroah.com>
References: <1379066161-8278-1-git-send-email-dominik.paulus@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379066161-8278-1-git-send-email-dominik.paulus@fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 11:55:50AM +0200, Dominik Paulus wrote:
> Hi,
> 
> this patch series includes an updated version of the IPv6 support patch (a call
> to freeaddrinfo() was missing) as well as:
> 
>  - The client/server authentication support using GnuTLS Tobias already
>    announced on the usbip-devel mailing list some time ago[1]
> 
>  - Support for restricting the access to devices to specific IP address ranges
> 
>  - Improved error reporting and new error codes to be passed over the TCP
>    protocol.
> 
> We think that the added features justify a version bump to 1.2.0. The
> corresponding patch is also included. All protocol changes are
> backwards-compatible, thus, we don't increment the protocol version.
> 
> We've already sent this patch series, but forgot to specify a subject line.
> linux-usb apparently received it[2], the LKML didn't. Sorry if you received it
> twice now.

Only the first patch could be applied. Can you refresh this series, and
your other one (fixing the issues pointed out there), and resend them
please?

thanks,

greg k-h
