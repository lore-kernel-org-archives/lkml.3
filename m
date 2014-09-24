Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaIXIL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:11:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbaIXILy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:11:54 -0400
Date: Tue, 23 Sep 2014 23:02:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: Re: [char-misc-next 1/6] mei: push all standard settings into
 mei_device_init
Message-ID: <20140924060202.GA26531@kroah.com>
References: <1409658604-31615-1-git-send-email-tomas.winkler@intel.com>
 <1409658604-31615-2-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409658604-31615-2-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 02:49:59PM +0300, Tomas Winkler wrote:
> Setting of hw_ops and device has should be in
> mei_device_init.
> We add reference to the parent device and remove
> pci dependent cfg
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>

This series didn't apply, can you fix it up and resend?

thanks,

greg k-h
