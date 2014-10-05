Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaJEOx1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 10:53:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34135 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaJEOx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 10:53:26 -0400
MIME-Version: 1.0
In-Reply-To: <1412429015-30564-4-git-send-email-German.Rivera@freescale.com>
References: <1412429015-30564-1-git-send-email-German.Rivera@freescale.com>
	<1412429015-30564-4-git-send-email-German.Rivera@freescale.com>
Date: Sun, 5 Oct 2014 09:53:24 -0500
Message-ID: <CAOZdJXWP4bwWiEcX10i4j96z49QahtpywK=XiuHm9VXWa0zOKw@mail.gmail.com>
Subject: Re: [PATCH 3/3 v3] drivers/bus: Device driver for FSL-MC DPRC devices
From: Timur Tabi <timur@codeaurora.org>
To: "J. German Rivera" <German.Rivera@freescale.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        stuart.yoder@freescale.com, Kim Phillips <Kim.Phillips@freescale.com>,
        Scott Wood <scottwood@freescale.com>, Alexander Graf <agraf@suse.de>,
        bhamciu1@freescale.com, R89243@freescale.com,
        Geoff.Thorpe@freescale.com, bhupesh.sharma@freescale.com,
        nir.erez@freescale.com, richard.schmitt@freescale.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 4, 2014 at 8:23 AM, J. German Rivera
<German.Rivera@freescale.com> wrote:
> +EXPORT_SYMBOL_GPL(dprc_scan_objects);

I didn't notice this earlier, but I it was Freescale policy to use
EXPORT_SYMBOL() instead of EXPORT_SYMBOL_GPL().  Has that changed?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by The Linux Foundation.
