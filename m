Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3EQDdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:33:22 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:37896 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab3EQDdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:33:20 -0400
Date: Thu, 16 May 2013 15:59:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/1] Staging: hv: Fix a bug in get_vp_index()
Message-ID: <20130516225943.GA12820@kroah.com>
References: <1368200821-20964-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368200821-20964-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 08:47:01AM -0700, K. Y. Srinivasan wrote:
> Linux' notion of cpuid is different from the Host's notion of CPUID. In the
> call to bind the channel interrupts, we should use the host's notion of
> CPU Ids. Fix this bug.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: Stable <stable@vger.kernel.org> (V3.9)
> ---
>  drivers/hv/channel_mgmt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Why do you have "Staging" in the Subject:?  This isn't a staging driver
anymore, right?

greg k-h
