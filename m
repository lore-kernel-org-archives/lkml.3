Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab3JaS4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 14:56:36 -0400
Received: from smtp181.dfw.emailsrvr.com ([67.192.241.181]:35094 "EHLO
	smtp181.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab3JaS4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 14:56:35 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Oct 2013 14:56:35 EDT
Date: Thu, 31 Oct 2013 19:45:09 +0100
From: Robert Richter <robert.richter@calxeda.com>
To: Robert Richter <rric@kernel.org>
Cc: linux-edac@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>
Subject: Re: [PATCH] edac, highbank: Moving error injection to sysfs for edac
Message-ID: <20131031184509.GI7429@rric.localhost>
References: <1383086873-13357-1-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383086873-13357-1-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.10.13 23:47:53, Robert Richter wrote:
> From: Robert Richter <robert.richter@linaro.org>
> 
> Always have the error injection i/f available, even if there is no
> debugfs or EDAC_DEBUG enabled. We need this for testing production
> kernels and environments.
> 
> Thus, the entry moves from:
> 
>  /sys/kernel/debug/edac/mc0/inject_ctrl
> 
> to:
> 
>  /sys/devices/system/edac/mc/mc0/inject_ctrl
> 
> No other changes of the interface.
> 
> Signed-off-by: Robert Richter <robert.richter@linaro.org>
> Signed-off-by: Robert Richter <rric@kernel.org>

After talking with Rob about the patch I applied it to my tree to be
pulled in the next merge window.

-Robert
