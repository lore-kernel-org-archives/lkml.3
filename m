Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3AXOto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 09:49:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:52279 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab3AXOtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 09:49:40 -0500
Date: Thu, 24 Jan 2013 06:51:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, davem@davemloft.net,
        James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH 5/6] Drivers: hid: hid-hyperv: Use consolidated GUID
 definitions
Message-ID: <20130124145109.GA7469@kroah.com>
References: <1358991737-22675-1-git-send-email-kys@microsoft.com>
 <1358991765-22715-1-git-send-email-kys@microsoft.com>
 <1358991765-22715-5-git-send-email-kys@microsoft.com>
 <alpine.LNX.2.00.1301241110210.31600@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1301241110210.31600@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 11:11:01AM +0100, Jiri Kosina wrote:
> On Wed, 23 Jan 2013, K. Y. Srinivasan wrote:
> 
> > Use the consolidated GUID definitions in the Hyper-V mouse driver.
> > 
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Acked-by: Jiri Kosina <jkosina@suse.cz>
> 
> Greg, I guess you are taking this as a whole?

Yes, I can do that, thanks for the ack.

greg k-h
