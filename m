Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271AbaEXSKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 14:10:54 -0400
Received: from mail-yk0-f178.google.com ([209.85.160.178]:56982 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaEXSKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 14:10:53 -0400
Date: Sat, 24 May 2014 15:10:15 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 1/2] of: Ensure unique names without sacrificing
 determinism
Message-ID: <20140524181014.GA4011@arch.cereza>
References: <1400801769-4506-1-git-send-email-grant.likely@linaro.org>
 <1400801769-4506-2-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400801769-4506-2-git-send-email-grant.likely@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 May 08:36 AM, Grant Likely wrote:
> The way the driver core is implemented, every device using the same bus
> type is required to have a unique name because a symlink to each device
> is created in the appropriate /sys/bus/*/devices directory, and two
> identical names causes a collision.
> 
> The current code handles the requirement by using an globally
> incremented counter that is appended to the device name. It works, but
> it means any change to device registration will change the assigned
> numbers. Instead, if we build up the name by using information from the
> parent nodes, then it can be guaranteed to be unique without adding a
> random number to the end of it.
> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>

Tested-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>

-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
