Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaFJTYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:24:09 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41179 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaFJTYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:24:07 -0400
Date: Tue, 10 Jun 2014 12:23:57 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: George Cherian <george.cherian@ti.com>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] watchdog: lantiq_wdt: Remove the un-necessary check
 of resource after platform_get_resource()
Message-ID: <20140610192357.GB7773@roeck-us.net>
References: <1402375208-18445-1-git-send-email-george.cherian@ti.com>
 <1402375208-18445-2-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402375208-18445-2-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 10:10:07AM +0530, George Cherian wrote:
> devm_ioremap_resource() checks for valid resource.
> Remove the un-necessary check after platform_get_resource().
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
