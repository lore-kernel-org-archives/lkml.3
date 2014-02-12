Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaBLQlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:41:40 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:49740 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbaBLQli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:41:38 -0500
Date: Wed, 12 Feb 2014 08:41:34 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <jdelvare@suse.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 09/12] hwmon: vexpress: Use devm helper for hwmon device
 registration
Message-ID: <20140212164134.GA19445@roeck-us.net>
References: <20140212024904.GA19352@roeck-us.net>
 <1392206196.848.18.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392206196.848.18.camel@hornet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 11:56:36AM +0000, Pawel Moll wrote:
> 
> > I agree with Arnd that it would be nice to get rid of the local macro,
> > but I won't mandate that.
> 
> I actually prefer to have the structures unfolded, but was just trying
> to mimic the trend in other hwmon drivers. No problem - will change this
> gladly.
> 
In general we tend to discourage people to use their own macros -
most of the time it just makes the code more difficult to read.

Guenter
