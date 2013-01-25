Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab3AYIUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:20:36 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:41535 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab3AYIUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:20:33 -0500
Date: Fri, 25 Jan 2013 00:20:30 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] Input: twl6040-vibra cleanups (devm_* conversion,
 system wq)
Message-ID: <20130125082030.GA21273@core.coreip.homeip.net>
References: <1358177678-16509-1-git-send-email-peter.ujfalusi@ti.com>
 <51011E9D.7050409@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51011E9D.7050409@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thu, Jan 24, 2013 at 12:44:29PM +0100, Peter Ujfalusi wrote:
> Hi Dmitry,
> 
> On 01/14/2013 04:34 PM, Peter Ujfalusi wrote:
> > Hi Dmitry,
> > 
> > Changes since v2:
> > - twl4030-vibra patches are left out (they have been applied)
> > - Do not use devm_input_allocate_device() in twl6040-vibra
> 
> Do you want me to resend this two patch for 3.9?

No, I queued them for 3.9.

Thanks.

-- 
Dmitry
