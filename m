Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaBKQ3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:29:50 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:52433 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaBKQ3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:29:47 -0500
Date: Tue, 11 Feb 2014 08:29:43 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 RESEND] ims-pcu: Add commands supported by the new
 version of the FW
Message-ID: <20140211162943.GB12106@core.coreip.homeip.net>
References: <1392132520-2497-1-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392132520-2497-1-git-send-email-andrew.smirnov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey,

On Tue, Feb 11, 2014 at 07:28:40AM -0800, Andrey Smirnov wrote:
> New version of the PCU firmware supports two new commands:
>   - IMS_PCU_CMD_OFN_SET_CONFIG which allows to write data to the
>   registers of one finger navigation(OFN) chip present on the device
>   - IMS_PCU_CMD_OFN_GET_CONFIG which allows to read data form the
>   registers of said chip.
> 
> This commit adds two helper functions to use those commands and sysfs
> attributes to use them. It also exposes some OFN configuration
> parameters via sysfs.
> 
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

I have it queued for the next merge window.

Thanks.

-- 
Dmitry
