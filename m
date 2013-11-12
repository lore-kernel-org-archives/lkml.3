Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab3KLNuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 08:50:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37178 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab3KLNuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 08:50:06 -0500
Date: Tue, 12 Nov 2013 14:50:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        cody@linux.vnet.ibm.com, schwidefsky@de.ibm.com, utz.bacher@de.ibm.com,
        mmarek@suse.cz, rmallon@gmail.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
Message-ID: <20131112135004.GA31957@amd.pavel.ucw.cz>
References: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The GenWQE device is a PCIe card used to acclerate different tasks.
> Since it is configurable, it can be adjusted to different purposes.
> Our initial task for the card is to do zlib style compression/decompression
> RFC1950, RFC1951, and RFC1952.

Is it similar to the Intel's Xeon Phi? They basically many-core have
computer on PCI card...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
