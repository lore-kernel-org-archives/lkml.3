Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaHTUK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:10:59 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33757 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaHTUK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:10:57 -0400
Date: Wed, 20 Aug 2014 13:10:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>,
        "open list:WATCHDOG DEVICE D..." <linux-watchdog@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] powerpc: booke_wdt: Fix build error as a module
Message-ID: <20140820201051.GA1745@roeck-us.net>
References: <1408562806-22950-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408562806-22950-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 03:26:46PM -0400, Pranith Kumar wrote:
> Building booke_wdt fails when trying to build as a module as there is no
> early_param() in module. Fix by using module_param() instead of early_param().
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> CC: Guenter Roeck <linux@roeck-us.net>

Looks good as far as I can see. One question though:

> +MODULE_ALIAS("booke_wdt");

Is this necessary ? If yes, shouldn't it be a separate patch to be applied
to -stable ?

Thanks,
Guenter
