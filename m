Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161040Ab3CVQhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:37:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42244 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1160998Ab3CVQhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:37:11 -0400
Date: Fri, 22 Mar 2013 16:36:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jon Hunter <jon-hunter@ti.com>
Cc: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mach_omap2: use PTR_RET instead of IS_ERR + PTR_ERR
Message-ID: <20130322163650.GN30923@n2100.arm.linux.org.uk>
References: <1363075109-27038-1-git-send-email-silviupopescu1990@gmail.com> <20130312110557.GF30923@n2100.arm.linux.org.uk> <5149FFDF.6050501@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5149FFDF.6050501@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 01:28:47PM -0500, Jon Hunter wrote:
> Sorry I am now not sure I follow you here. Someone just pointed out to
> me that PTR_RET() is defined as ...
> 
> static inline int __must_check PTR_RET(const void *ptr)
> {
> 	if (IS_ERR(ptr))
> 		return PTR_ERR(ptr);
> 	else
> 		return 0;
> }
> 
> So the above change appears to be equivalent. Is there something that is
> wrong with the current implementation that needs to be fixed?

No - I misread it as PTR_ERR not PTR_RET.  Your patch is fine.
