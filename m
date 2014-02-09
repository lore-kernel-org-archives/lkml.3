Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaBIUI1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:08:27 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33317 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbaBIUIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:08:24 -0500
Date: Sun, 9 Feb 2014 12:08:23 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [03/10] watchdog: xilinx: Simplify probe and remove functions
Message-ID: <20140209200823.GA1697@roeck-us.net>
References: <578455fd630e70b5de8bae6091568f05e7769057.1391177880.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <578455fd630e70b5de8bae6091568f05e7769057.1391177880.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 10:18:12PM -0000, Michal Simek wrote:
> Use devm_ helper function to simplify probe and error path.
> Move ioremap to the beginning of probe function.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> 
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
