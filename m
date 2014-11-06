Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaKFScS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:32:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaKFScP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:32:15 -0500
Date: Thu, 6 Nov 2014 10:32:14 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: 8250_core: use pre-decrement for iteration limit
Message-ID: <20141106183214.GA24232@kroah.com>
References: <1413212951-20901-1-git-send-email-frans.klaver@xsens.com>
 <20141014115234.GB15616@ci00147.xsens-tech.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141014115234.GB15616@ci00147.xsens-tech.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 01:52:34PM +0200, Frans Klaver wrote:
> On Mon, Oct 13, 2014 at 05:09:11PM +0200, Frans Klaver wrote:
> > In serial8250_rx_chars(), max_count is set to 256. Due to the
> > post-decrement operator used in the while() condition, the maximum
> > number of iterations actually 257. This is not a problem, but it is
> > mildly surprising if you're debugging. Use pre-decrement instead.
> 
> I'm somewhat inclined to changing the title to something like:
> 
> serial: 8250_core: actually limit char reads to max_count

Sounds better, care to resend with that subject:?

