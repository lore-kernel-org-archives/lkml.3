Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbbAFN2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:28:24 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:60546 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbbAFN2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:28:22 -0500
Date: Tue, 6 Jan 2015 14:28:16 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] next: microblaze: Fix build failure
Message-ID: <20150106132816.GA6465@localhost.localdomain>
References: <1420296800-17045-1-git-send-email-linux@roeck-us.net>
 <20150103170118.GA8958@localhost.localdomain>
 <20150105085212.GA11117@roeck-us.net>
 <20150105135259.GB8156@localhost.localdomain>
 <20150105144322.GA8843@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105144322.GA8843@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 03:43:22PM +0100, Richard Cochran wrote:
> A better fix would be to add this one line into
> 
> 	include/clocksource/arm_arch_timer.h

On second glance, this is not right. I just posted the correct fix.

Thanks,
Richard
