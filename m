Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbaHGGwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:52:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbaHGGwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:52:45 -0400
Date: Thu, 7 Aug 2014 08:52:35 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: kreijack@inwind.it, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] Export the temperatures via hwmon
Message-ID: <20140807085235.2c0e63dd@endymion.delvare>
In-Reply-To: <53E31AB0.6070604@roeck-us.net>
References: <1407359103-6012-1-git-send-email-kreijack@inwind.it>
	<1407359103-6012-6-git-send-email-kreijack@inwind.it>
	<20140806231803.GA5643@roeck-us.net>
	<53E31694.8050107@gmail.com>
	<53E31AB0.6070604@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Wed, 06 Aug 2014 23:20:32 -0700, Guenter Roeck wrote:
> Patch 4/5 is "Return the fan speed via sysfs: /sys/devices/temperature/fan_level".
> 
> So you are saying that returning the fan speed with a non-hwmon attribute works,
> but returning it with a hwmon attribute doesn't ? Not really sure if I understand
> your logic. Either fan_level doesn't return the fan speed (or an abstraction of it),
> or something in your line of argument is inconsistent.

fan_level is a fan speed _control_ value, like pwm1. It is not a fan
speed monitoring value.

-- 
Jean Delvare
SUSE L3 Support
