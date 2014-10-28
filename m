Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbaJ1Rul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:50:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42307 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaJ1Rui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:50:38 -0400
Date: Tue, 28 Oct 2014 18:50:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH v3 47/47] kernel: Remove pm_power_off
Message-ID: <20141028175036.GC11668@amd>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <1414425354-10359-48-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414425354-10359-48-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-10-27 08:55:54, Guenter Roeck wrote:
> No users of pm_power_off are left, so it is safe to remove the function.
> 
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
