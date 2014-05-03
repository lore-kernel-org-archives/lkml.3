Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaEDBCE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 21:02:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbaEDBCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 21:02:02 -0400
Date: Sat, 3 May 2014 19:52:33 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Chase Southwood <chase.southwood@gmail.com>, devel@driverdev.osuosl.org,
        abbotti@mev.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] staging: comedi: addi_apci_1564: remove eeprom
 support code
Message-ID: <20140503235233.GA7976@kroah.com>
References: <1398562558-5354-1-git-send-email-chase.southwood@gmail.com>
 <20140428094005.GU26890@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428094005.GU26890@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 12:40:05PM +0300, Dan Carpenter wrote:
> Nice, Chase, you've become an expert on comedi, it seems.
> 
> I can't say how happy comedi patches make me these days.  Ian, you and
> Hartley are doing a fantastic job.

Same here, it's great to see all of this cleanup happening.  Maybe
someday it can move out of staging...  :)

thanks,

greg k-h
