Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934564Ab3DHJ4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:56:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:50639 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934782Ab3DHJ4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:56:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,429,1363158000"; 
   d="scan'208";a="315809755"
Date: Mon, 8 Apr 2013 11:56:01 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] mfd: support stmpe1801 18 bits enhanced port expander
Message-ID: <20130408095601.GP24058@zurbaran>
References: <1361206222-2341-1-git-send-email-jean-nicolas.graux@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361206222-2341-1-git-send-email-jean-nicolas.graux@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Nicolas,

On Mon, Feb 18, 2013 at 05:50:22PM +0100, Jean-Nicolas Graux wrote:
> Provides support for 1801 variant of stmpe gpio port expanders.
> This chip has 18 gpios configurable as GPI, GPO, keypad matrix,
> special key or dedicated key function.
> 
> Note that special/dedicated key function is not supported yet.
> 
> Change-Id: I6ea89af7b96e9a02478ebec3467291e7d7c510c9
No Change-Id, please.

> Signed-off-by: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
> ---
>  drivers/gpio/gpio-stmpe.c             |   52 +++++--
>  drivers/input/keyboard/stmpe-keypad.c |  267 ++++++++++++++++++++++++++-------
>  drivers/mfd/Kconfig                   |    1 +
>  drivers/mfd/stmpe-i2c.c               |    1 +
>  drivers/mfd/stmpe.c                   |   97 +++++++++++-
>  drivers/mfd/stmpe.h                   |   49 ++++++
>  include/linux/mfd/stmpe.h             |    3 +
>  7 files changed, 398 insertions(+), 72 deletions(-)
This should be splitted into 3 patches, an mfd one and then an input and a
gpio one. I would carry all 3 of them through the MFD tree on order to handle
build dependencies.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
