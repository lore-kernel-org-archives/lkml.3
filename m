Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab3AKURL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:17:11 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:53320 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab3AKURJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:17:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH 4/4] serial/arc-uart: switch to devicetree based probing
Date: Fri, 11 Jan 2013 20:17:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Grant Likely" <grant.likely@secretlab.ca>,
        Alan Cox <alan@linux.intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
References: <1357885223-19243-1-git-send-email-vgupta@synopsys.com> <201301111133.43507.arnd@arndb.de> <50EFFDAA.6060204@synopsys.com>
In-Reply-To: <50EFFDAA.6060204@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301112017.04270.arnd@arndb.de>
X-Provags-ID: V02:K0:0Beim5LSoNIbWcxI7xv6/xDklARKyAoJ41Wlus5n05X
 QXu3w+zTgZOMD9W6WPta71lzJYyRE8iunm1XNgImGtqKjMRk2o
 Xk491driNS8BqEUXNAcQHJjCoVTIGBkCe20S1/r0PAtSSqGIrC
 8wq7dQyFlp3XcVVz8wDPwD/3y+uRUKAn9umILx0Z6mBeLlCRFj
 h4e9vA84AvE1qLEbtTn6Q8nezHQNx+v6AW+s0xR/wjhUqtPlIS
 eHWo5a4IyGh6XUOmY65Lf5yqwwZbfVM0sU1iSAyvjeARHv4oh5
 WSG1myvwvHCtSpwb1s6tYrjiL8QK1uUWiKrUOZ41TOIlwbtyPv
 GCZJH8/c4ESz9gUQeBsk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 January 2013, Vineet Gupta wrote:
> On Friday 11 January 2013 05:03 PM, Arnd Bergmann wrote:

> > Quick question about the name though: is this UART only used
> > on ARC, or is it something that synopsys licenses to other
> > parties as well? If the latter is true, we might want to 
> > add a more generic "compatible" value for those that use
> > it on another architecture.
> 
> It's not licensed as standalone IP - since its not a standard 8250. It is only
> (but actively) used on the internal FPGA flows from ARC days.
> 
Ok, thanks for the confirmation.

	Arnd
