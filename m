Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbaJOHuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 03:50:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35142 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaJOHuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 03:50:03 -0400
Date: Wed, 15 Oct 2014 09:50:01 +0200
From: Pavel Machek <pavel@denx.de>
To: atull@opensource.altera.com
Cc: dinguyen@opensource.altera.com, linux@arm.linux.org.uk, arnd@arndb.de,
        s.trumtrar@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH v3 2/2] socfpga: support suspend to ram
Message-ID: <20141015075001.GB10720@amd>
References: <1413315219-28885-1-git-send-email-atull@opensource.altera.com>
 <1413315219-28885-3-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413315219-28885-3-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-10-14 14:33:39, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Add code that requests that the sdr controller go into
> self-refresh mode.  This code is run from ocram.
> 
> This patch assumes that u-boot has already configured sdr:
>   sdr.ctrlcfg.lowpwreq.selfrfshmask = 3
>   sdr.ctrlcfg.lowpwrtiming.clkdisablecycles = 8
>   sdr.ctrlcfg.dramtiming4.selfrfshexit = 512
> 
> How to suspend to ram:
>  $ echo enabled > \
> /sys/devices/soc/ffc02000.serial0/tty/ttyS0/power/wakeup
> 
>  $ echo -n mem > /sys/power/state
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>

Acked-by: Pavel Machek <pavel@denx.de>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
