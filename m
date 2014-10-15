Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaJOHtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 03:49:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35090 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaJOHtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 03:49:01 -0400
Date: Wed, 15 Oct 2014 09:48:58 +0200
From: Pavel Machek <pavel@denx.de>
To: atull@opensource.altera.com
Cc: dinguyen@opensource.altera.com, linux@arm.linux.org.uk, arnd@arndb.de,
        s.trumtrar@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH v3 1/2] socfpga: hotplug: put cpu1 in wfi
Message-ID: <20141015074858.GA10720@amd>
References: <1413315219-28885-1-git-send-email-atull@opensource.altera.com>
 <1413315219-28885-2-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413315219-28885-2-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-10-14 14:33:38, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Use WFI when putting CPU1 to sleep.  Don't hold CPU1 in reset
> since that results in increased power consumption.
> 
> Reset CPU1 briefly during CPU1 bootup.
> 
> This has been tested for hotplug and suspend/resume and results
> in no increased power consumption.
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>

Acked-by: Pavel Machek <pavel@denx.de>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
