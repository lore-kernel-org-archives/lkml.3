Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbaIWTGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:06:41 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:33026 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbaIWTGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:06:39 -0400
Date: Tue, 23 Sep 2014 19:06:14 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>, Daniel Mack <daniel@caiaq.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: core: downgrade log severity to info when descriptor
 missing
In-Reply-To: <Pine.LNX.4.44L0.1409231021190.1322-100000@iolanthe.rowland.org>
Message-ID: <alpine.DEB.2.11.1409231905460.3223@localhost.localdomain>
References: <Pine.LNX.4.44L0.1409231021190.1322-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014, Alan Stern wrote:
> -ENODATA doesn't mean the string was unavailable.  It means that the
> second byte of the reply was different from USB_DT_STRING, i.e., the
> reply was malformed.

Thank you for the correction!

> And down here is where you should call either dev_info() or dev_err(),
> depending on whether err is equal to -EPIPE or something else.

I hope to send it shortly.
