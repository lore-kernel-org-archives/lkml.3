Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaJMGzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 02:55:44 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.97]:53981 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbaJMGzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 02:55:40 -0400
Message-ID: <543B7765.6050004@ladisch.de>
Date: Mon, 13 Oct 2014 08:55:33 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Gene Heskett <gheskett@wdtv.com>, linux-kernel@vger.kernel.org
Subject: Re: reboot housekeeping, lack thereof, is messing with me
References: <201410121321.26582.gheskett@wdtv.com>
In-Reply-To: <201410121321.26582.gheskett@wdtv.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> To whomever is in charge of the supposedly volatile LCK.. files in
> /var/lock:

Whoever that may be, it's not the kernel.

> Its my understanding that these files should be volatile when they
> represent a USB usage, because a USB device can be unplugged instantly and
> at any time.  The device nicely and dutifully disappears from an 'ls /dev'
> listing when a device is unplugged.
>
> Why is it then that the /var/lock/LCK..ttyUSB1 file is always left behind,
> so it screws up any possibility of doing a nice clean reboot and restart
> of the program that uses it?

What program leaves this file behind?  (The pid in there is no longer
helpful, unless it got logged due to a segfault, but what was the last
program used for serial stuff?)

Anyway, it appears some programs automatically delete this file when the
pid is not valid.


Regards,
Clemens
