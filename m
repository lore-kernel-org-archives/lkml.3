Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbaDVHKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:10:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52035 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaDVHJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:09:58 -0400
Date: Tue, 22 Apr 2014 09:09:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] PM / Hibernate: no kernel_power_off when
 pm_power_off NULL
Message-ID: <20140422070955.GA14108@amd.pavel.ucw.cz>
References: <1398126646-29518-1-git-send-email-sebastian.capella@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398126646-29518-1-git-send-email-sebastian.capella@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-04-21 17:30:46, Sebastian Capella wrote:
> Reboot logic in kernel/reboot will avoid calling kernel_power_off
> when pm_power_off is null, and instead uses kernel_halt.  Change
> hibernate's power_down to follow the behavior in the reboot call.
> 
> Calling the notifier twice (once for SYS_POWER_OFF and again for
> SYS_HALT) causes a panic during hibernation on Kirkwood
> Openblocks A6 board.
> 
> Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
> Reported-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> Cc: Len Brown <len.brown@intel.com>

Reviewed-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
