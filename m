Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaLTAVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 19:21:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45805 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaLTAVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 19:21:33 -0500
Date: Sat, 20 Dec 2014 01:21:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, anton@enomsg.org,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com
Subject: Re: [PATCH V3 01/11] power: charger-manager: Use alarmtimer for
 battery monitoring in suspend.
Message-ID: <20141220002129.GB1694@amd>
References: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
 <1418979323-7188-2-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418979323-7188-2-git-send-email-jonghwa3.lee@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-12-19 17:55:13, Jonghwa Lee wrote:
> To guerantee proper charing and managing batteries even in suspend,
> charger-manager has used rtc device with rtc framework interface.
> However, it is better to use alarmtimer for cleaner and more appropriate
> operation.
> This patch makes driver to use alamtimer for polling work in suspend and

alarmtimer.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
