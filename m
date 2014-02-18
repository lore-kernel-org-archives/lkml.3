Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaBRVq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:46:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaBRVqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:46:55 -0500
Date: Tue, 18 Feb 2014 13:48:19 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers: Introduce MEN Chameleon Bus
Message-ID: <20140218214819.GA20495@kroah.com>
References: <1392737654-22682-1-git-send-email-johannes.thumshirn@men.de>
 <1392737654-22682-2-git-send-email-johannes.thumshirn@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392737654-22682-2-git-send-email-johannes.thumshirn@men.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 04:34:12PM +0100, Johannes Thumshirn wrote:
> The MCB (MEN Chameleon Bus) is a Bus specific to MEN Mikroelektronik
> FPGA based devices. It is used to identify MCB based IP-Cores within
> an FPGA and provide the necessary framework for instantiating drivers
> for these devices.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>

Looks good to me, nice job with the driver core integration.

Want me to queue this up through my tree?  Or do you want to have it go
through somewhere else?

thanks,

greg k-h
