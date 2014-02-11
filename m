Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbaBKUR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:17:26 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:55563 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbaBKURV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:17:21 -0500
Date: Tue, 11 Feb 2014 12:17:18 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 11/11] watchdog: xilinx: Remove no_timeout variable
Message-ID: <20140211201718.GB11798@roeck-us.net>
References: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
 <52d86e3f2b957411deafbdfbd4bf93bb78f491ac.1392101734.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52d86e3f2b957411deafbdfbd4bf93bb78f491ac.1392101734.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 07:55:54AM +0100, Michal Simek wrote:
> Remove no_timeout variable and check variables
> directly.
> 
> Suggested-by: Rob Herring <robherring2@gmail.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
