Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3A1ILY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 03:11:24 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:59119 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3A1ILX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 03:11:23 -0500
Date: Mon, 28 Jan 2013 08:11:16 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Philippe Langlais <philippe.langlais@linaro.org>
Subject: Re: [PATCH 26/26] mfd: ab8500-gpadc: Use new ab8500_gpadc_get() with
 name parameter
Message-ID: <20130128081116.GW15873@gmail.com>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-27-git-send-email-lee.jones@linaro.org>
 <20130127235405.GU1174@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130127235405.GU1174@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, Samuel Ortiz wrote:

> Hi Lee,
> 
> On Tue, Jan 15, 2013 at 12:56:06PM +0000, Lee Jones wrote:
> > From: Philippe Langlais <philippe.langlais@linaro.org>
> > 
> > The new format of ab8500_gpadc_get() accepts a device name as a
> > parameter to specify which device to retrieve. This patch
> > enforces the use of that new format.
> Where is that new API coming from ? I couldn't find it in the previous 25
> patches. If it's there, this one should be merged with the patch that changes
> this API.

The API is already upstream:

6321992c (Daniel Willerud  2011-03-05 11:46:13 +0100 133) struct
  ab8500_gpadc *ab8500_gpadc_get(char *name)

The branch I'm trying to upstream from used the old one before now.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
