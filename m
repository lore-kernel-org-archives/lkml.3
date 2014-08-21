Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbaHUSrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 14:47:19 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:42586 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaHUSrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 14:47:18 -0400
Date: Thu, 21 Aug 2014 11:47:14 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: ts72xx_wdt: Kill superfluous variable in remove
Message-ID: <20140821184714.GA16681@roeck-us.net>
References: <1408449432-25274-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408449432-25274-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 02:57:12PM +0300, Mika Westerberg wrote:
> There is no need to store the return value of misc_deregister() in a
> variable. Instead we can just return the value directly.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
