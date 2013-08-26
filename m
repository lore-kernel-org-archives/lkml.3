Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3HZVyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 17:54:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab3HZVyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 17:54:40 -0400
Date: Mon, 26 Aug 2013 14:56:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in the handling of
 channel offers
Message-ID: <20130826215656.GA2276@kroah.com>
References: <1377551338-29582-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377551338-29582-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 02:08:58PM -0700, K. Y. Srinivasan wrote:
> The channel state should be correctly set before registering the device. In the current
> code the driver probe would fail for channels that have been rescinded and subsequently
> re-offered. Fix the bug.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: <stable@vger.kernel.org>

What older kernel versions have this bug?  When did it show up?

thanks,

greg k-h
