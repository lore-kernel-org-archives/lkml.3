Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbbACRB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 12:01:26 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:44711 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbbACRBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 12:01:23 -0500
Date: Sat, 3 Jan 2015 18:01:18 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH] next: microblaze: Fix build failure
Message-ID: <20150103170118.GA8958@localhost.localdomain>
References: <1420296800-17045-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420296800-17045-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2015 at 06:53:20AM -0800, Guenter Roeck wrote:
> Microblaze build in linux-next fails with
> 
> arch/microblaze/kernel/timer.c:224:2: error:
> 	implicit declaration of function 'timecounter_init'
> 
> Caused by missing include file in microblaze timer code.

Already fixed in net-next.

Thanks,
Richard
