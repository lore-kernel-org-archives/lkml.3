Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab3J0RbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 13:31:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab3J0RbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 13:31:14 -0400
Date: Sun, 27 Oct 2013 10:33:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rob Pearce <rob@flitspace.org.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] INTEL DRM DRIVERS : No LVDS hardware on Intel D410PT and
 D425KT
Message-ID: <20131027173302.GA25812@kroah.com>
References: <526D3BB6.6020902@flitspace.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526D3BB6.6020902@flitspace.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 04:13:42PM +0000, Rob Pearce wrote:
> From: Rob Pearce <rob@flitspace.org.uk>
> 
> The Intel D410PT(LW) and D425KT Mini-ITX desktop boards both show up as
> having LVDS but the hardware is not populated. This patch adds them to
> the list of such systems. Patch is against 3.11.4
> 
> Signed-off-by: Rob Pearce <rob@flitspace.org.uk>
> ---
> Patch revised to match the D425KT exactly as the D425KTW does have LVDS. 
> According to Intel's documentation, the D410PTL and D410PLTW don't.

Any reason you don't want this in the stable tree as well?

thanks,

greg k-h
