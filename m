Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750921Ab3FDRxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:53:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37319 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764Ab3FDRxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:53:44 -0400
X-Sasl-enc: Ghl0nO/5WR6TgowGZDmGajeaPi8F7YfjfmRfgbwMWcpy 1370368423
Date: Tue, 4 Jun 2013 10:53:42 -0700
From: Greg KH <greg@kroah.com>
To: Tobias Winter <tobias@linuxdingsda.de>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] raise the maximum number of usb-serial devices to 512
Message-ID: <20130604175342.GA10935@kroah.com>
References: <20130604024959.GA10697@kroah.com>
 <51AE2378.507@linuxdingsda.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AE2378.507@linuxdingsda.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 07:27:20PM +0200, Tobias Winter wrote:
> On 04.06.2013 04:49, Greg KH wrote:
> > Tobias, can you test this patch out?  Note, I only compiled it, did not
> > get the chance to actually run it, so it might not work at all.
> 
> Sure, I'll gladly give it a try. Seeing the comments on the code, I'm
> just wondering if there might be a more recent version to run?

Give me a day, it's going to take some more reworks to get this all to
work properly, I'll send a new patch series then.

thanks,

greg k-h
