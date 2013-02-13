Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468Ab3BMAqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:46:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab3BMAqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:46:03 -0500
Date: Tue, 12 Feb 2013 16:46:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: MAINTAINERS: Remove Mark M. Hoffman
Message-Id: <20130212164601.c348b670.akpm@linux-foundation.org>
In-Reply-To: <20130208105437.347ea5b4@endymion.delvare>
References: <20130208105437.347ea5b4@endymion.delvare>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2013 10:54:37 +0100
Jean Delvare <khali@linux-fr.org> wrote:

> Mark M. Hoffman stopped working on the Linux kernel several years
> ago, so he should no longer be listed as a driver maintainer. I'm not
> even sure if his e-mail address still works.
> 
> I can take over 3 drivers he was responsible for, the 4th one will
> fall down to the subsystem maintainer.

It's nice to give developers a mention in ./CREDITS if we're to expunge
them from ./MAINTAINERS.  Something like this?

--- a/CREDITS~maintainers-remove-mark-m-hoffman-fix
+++ a/CREDITS
@@ -1510,6 +1510,11 @@ D: Natsemi ethernet
 D: Cobalt Networks (x86) support
 D: This-and-That
 
+N: Mark M. Hoffman
+E: mhoffman@lightlink.com
+D: Maintenance of drivers/hwmon/asb100.c, drivers/i2c/busses/i2c-sis96x.c
+D: i2c core contributions
+
 N: Dirk Hohndel
 E: hohndel@suse.de
 D: The XFree86[tm] Project
_

