Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162800Ab3DEVmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 17:42:04 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:39400 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162524Ab3DEVmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 17:42:03 -0400
X-Originating-Ip: 216.16.235.2
Date: Fri, 5 Apr 2013 17:42:00 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: linux-kernel@vger.kernel.org
Subject: Re: libata: how to duplicate the exact xfer_mask?
Message-ID: <20130405214200.GA8803@foursquare.net>
References: <20130405050725.GB27991@foursquare.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130405050725.GB27991@foursquare.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 01:07:25AM -0400, Chris Frey wrote:
> I'd like to duplicate these settings, so that it does not timeout, but
> when I use:
> 
> 	libata.force=ata1:udma/44,ata1:pio4

I figured out what I was doing wrong.  It should be:

	libata.force=1:udma/44,1:pio4

- Chris

