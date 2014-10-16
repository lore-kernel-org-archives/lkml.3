Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbaJPI37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:29:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaJPI35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:29:57 -0400
Date: Thu, 16 Oct 2014 10:28:52 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcm_wimax: remove driver support
Message-ID: <20141016082852.GA22210@kroah.com>
References: <1413413607-5058-1-git-send-email-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413413607-5058-1-git-send-email-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 03:53:27PM -0700, Jeff Kirsher wrote:
> The Beceem WiMAX driver was barely function in its current state
> and was non-functional on 64 bit systems.  Based on repeated
> statements from Greg KH that he wanted the driver removed, I am
> removing the driver.
> 
> CC: Matthias Beyer <mail@beyermatthias.de>
> CC: Kevin McKinney <klmckinney1@gmail.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Many thanks for this, I've now applied this to my testing tree.

greg k-h
