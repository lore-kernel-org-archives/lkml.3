Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbaHDOHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:07:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55146 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751581AbaHDOHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:07:22 -0400
Date: Mon, 4 Aug 2014 10:07:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: gregkh@linuxfoundation.org, <balbi@ti.com>, <ming.lei@canonical.com>,
        <mwelling@emacinc.com>, <stefan@herbrechtsmeier.net>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "[3.8+]" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: hub: Prevent hub autosuspend if usbcore.autosuspend
 is -1
In-Reply-To: <1407145486-14013-1-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1408041006530.1169-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2014, Roger Quadros wrote:

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

Acked-by: Alan Stern <stern@rowland.harvard.edu>

