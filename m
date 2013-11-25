Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab3KYSHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 13:07:47 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:51355 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab3KYSHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 13:07:46 -0500
Date: Mon, 25 Nov 2013 10:07:41 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: David Airlie <airlied@linux.ie>
Cc: lm-sensors@lm-sensors.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/radeon/dpm: Convert to use
 devm_hwmon_register_with_groups
Message-ID: <20131125180741.GA20159@roeck-us.net>
References: <1385185921-17220-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385185921-17220-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 09:52:00PM -0800, Guenter Roeck wrote:
> Simplify the code and fix race condition seen because
> attribute files were created after hwmon device registration.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> Compile tested only; unfortunately I don't have the the necessary hardware.
> 
Update: Tested working on actual hardware.

Guenter
