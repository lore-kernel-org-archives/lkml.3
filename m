Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaJ2BwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 21:52:04 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33331 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaJ2BwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 21:52:03 -0400
Date: Tue, 28 Oct 2014 18:51:58 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Marc Carino <marc.ceeeee@gmail.com>
Subject: Re: [PATCH v2 10/10] power/reset: brcmstb: Register with kernel
 restart handler
Message-ID: <20141029015158.GC23619@ld-irv-0074>
References: <1412099316-23167-1-git-send-email-linux@roeck-us.net>
 <1412099316-23167-11-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412099316-23167-11-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 10:48:36AM -0700, Guenter Roeck wrote:
> Register with kernel restart handler instead of setting arm_pm_restart directly.
> 
> Cc: Marc Carino <marc.ceeeee@gmail.com>
> Cc: Brian Norris <computersforpeace@gmail.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Tested on top of linux-next:

Tested-by: Brian Norris <computersforpeace@gmail.com>
Acked-by: Brian Norris <computersforpeace@gmail.com>
