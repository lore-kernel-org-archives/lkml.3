Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbaIRNRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:17:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42413 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbaIRNRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:17:19 -0400
Date: Thu, 18 Sep 2014 15:17:16 +0200
From: Pavel Machek <pavel@denx.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Russell King <linux@arm.linux.org.uk>, Dinh Nguyen <dinh.linux@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Dinh Nguyen <dinguyen@altera.com>, Kevin Hilman <khilman@linaro.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Revert "init: make rootdelay=N consistent with rootwait
 behaviour"
Message-ID: <20140918131716.GA29533@amd>
References: <20140917142542.GA5225@windriver.com>
 <1410965865-5547-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410965865-5547-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-09-17 10:57:45, Paul Gortmaker wrote:
> This reverts commit 4dfe694f616e00e6fd83e5bbcd7a3c4d7113493d.

This solves my problems, thanks.

Tested-by: Pavel Machek <pavel@denx.de>

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
