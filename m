Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbbAEOn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:43:29 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:63576 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbAEOn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:43:28 -0500
Date: Mon, 5 Jan 2015 15:43:22 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH] next: microblaze: Fix build failure
Message-ID: <20150105144322.GA8843@localhost.localdomain>
References: <1420296800-17045-1-git-send-email-linux@roeck-us.net>
 <20150103170118.GA8958@localhost.localdomain>
 <20150105085212.GA11117@roeck-us.net>
 <20150105135259.GB8156@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105135259.GB8156@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 02:52:59PM +0100, Richard Cochran wrote:
> Nope. It probably needs just one line:
> 
> + #include <linux/timecounter.h>

A better fix would be to add this one line into

	include/clocksource/arm_arch_timer.h

because that will fix

	virt/kvm/arm/arch_timer.c

which I surely also broke.

Thanks,
Richard
