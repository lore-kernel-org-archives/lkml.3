Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaHDPpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:45:54 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:43577 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaHDPpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:45:52 -0400
Date: Mon, 4 Aug 2014 10:45:44 -0500
From: Michael Welling <mwelling@emacinc.com>
To: Roger Quadros <rogerq@ti.com>
Cc: gregkh@linuxfoundation.org, stern@rowland.harvard.edu, balbi@ti.com,
        ming.lei@canonical.com, stefan@herbrechtsmeier.net,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "[3.8+]" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: hub: Prevent hub autosuspend if usbcore.autosuspend
 is -1
Message-ID: <20140804154544.GA23378@sysresccd>
References: <1407145486-14013-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407145486-14013-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 12:44:46PM +0300, Roger Quadros wrote:
> If user specifies that USB autosuspend must be disabled by module
> parameter "usbcore.autosuspend=-1" then we must prevent
> autosuspend of USB hub devices as well.
> 
> commit 596d789a211d introduced in v3.8 changed the original behaivour
> and stopped respecting the usbcore.autosuspend parameter for hubs.
> 
> Fixes: 596d789a211d "USB: set hub's default autosuspend delay as 0"
> 
> Cc: [3.8+] <stable@vger.kernel.org>
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Tested-by: Michael Welling <mwelling@emacinc.com>
