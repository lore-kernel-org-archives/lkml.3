Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab3C0JhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:37:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58314 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab3C0Jg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:36:58 -0400
Date: Wed, 27 Mar 2013 09:36:55 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [PATCH 138/150] sfc: Disable soft interrupt handling during
 efx_device_detach_sync()
Message-ID: <20130327093655.GB3103@hercules>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
 <1364311249-14454-139-git-send-email-luis.henriques@canonical.com>
 <1364344455.2922.4.camel@bwh-desktop.uk.solarflarecom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364344455.2922.4.camel@bwh-desktop.uk.solarflarecom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 12:34:15AM +0000, Ben Hutchings wrote:
> On Tue, 2013-03-26 at 15:20 +0000, Luis Henriques wrote:
> > 3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.
> [...]
> 
> I applied all 16 of the sfc patches on top of 3.5.7.8 and the result
> passed our standard 'overnight' test suite for in-tree drivers.
> 

Great, thanks a lot for reporting that Ben.

Cheers,
--
Luis
