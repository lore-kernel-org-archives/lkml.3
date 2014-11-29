Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaK2St1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 13:49:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaK2St0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 13:49:26 -0500
Date: Sat, 29 Nov 2014 10:48:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        joshc@codeaurora.org, johannes.thumshirn@men.de,
        kheitke@codeaurora.org, laurent.pinchart+renesas@ideasonboard.com,
        geert+renesas@glider.be, horms+renesas@verge.net.au,
        damm@opensource.se, tomi.valkeinen@ti.com, mbohan@codeaurora.org,
        michal.simek@xilinx.com, pawel.moll@arm.com, Andrew.Thoelke@arm.com
Subject: Re: [RFC PATCH 0/3] Generic TrustZone Driver in Linux Kernel
Message-ID: <20141129184801.GA1214@kroah.com>
References: <1417187016-7731-1-git-send-email-javier@javigon.com>
 <20141129181853.GR22670@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141129181853.GR22670@titan.lakedaemon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 01:18:53PM -0500, Jason Cooper wrote:
> 
> And as GregKH mentioned, this definitely needs some cleanup before
> expecting others to spend time reviewing.  If this code is working for
> your usecase, perhaps the staging tree might be a better place to
> start.

No, it needs lots of work before the staging tree can accept it (hint,
the FIXMEs are good places to start...)

greg k-h
