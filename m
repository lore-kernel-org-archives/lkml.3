Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbaHSI7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:59:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37948 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaHSI7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:59:35 -0400
Date: Tue, 19 Aug 2014 10:59:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Amit Pundir <amit.pundir@linaro.org>
Cc: linux-kernel@vger.kernel.org, Todd Poynor <toddpoynor@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC][PATCH 1/2] PM: Print pending wakeup IRQ preventing suspend
 to dmesg
Message-ID: <20140819085933.GA7862@amd>
References: <1406910649-4028-1-git-send-email-amit.pundir@linaro.org>
 <1406910649-4028-2-git-send-email-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406910649-4028-2-git-send-email-amit.pundir@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-08-01 22:00:48, Amit Pundir wrote:
> From: Todd Poynor <toddpoynor@google.com>
> 
> Currently when a pending wakeup irq stops suspend, it can be difficult
> to determine why suspend was prevented and which IRQ was actually
> responsible.
> 
> In order to help debug these situations, this patch prints the IRQ
> number and action name of that pending wakeup irq which prevents suspend.
> This patch comes from the Android patch set, where its been used to debug
> suspend problems.
> 

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
