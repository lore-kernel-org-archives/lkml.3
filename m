Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaBGXUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 18:20:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaBGXUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 18:20:15 -0500
Date: Fri, 7 Feb 2014 15:21:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH V2 1/1] Drivers: hv: vmbus: Extract the mmio information
 from DSDT
Message-ID: <20140207232124.GA23544@kroah.com>
References: <1391048079-13975-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391048079-13975-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 06:14:39PM -0800, K. Y. Srinivasan wrote:
> On Gen2 firmware, Hyper-V does not emulate the PCI bus. However, the MMIO
> information is packaged up in DSDT. Extract this information and export it
> for use by the synthetic framebuffer driver. This is the only driver that
> needs this currently.

I don't see a follow-on patch that uses these variables, where is that?

thanks,

greg k-h
