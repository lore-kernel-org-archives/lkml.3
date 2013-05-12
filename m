Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab3ELXzN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 19:55:13 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55110 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3ELXzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 19:55:12 -0400
X-Originating-IP: 108.223.40.66
Date: Sun, 12 May 2013 16:55:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Imre Deak <imre.deak@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH 04/11] hwmon/lm63,lm90: take msecs_to_jiffies_min into use
Message-ID: <20130512235519.GA13521@roeck-us.net>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
 <1368188011-23661-4-git-send-email-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368188011-23661-4-git-send-email-imre.deak@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 03:13:22PM +0300, Imre Deak wrote:
> Use msecs_to_jiffies_min instead of open-coding the same.
> 
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> ---

Function name could be better. Other than that,

Acked-by: Guenter Roeck <linux@roeck-us.net>
