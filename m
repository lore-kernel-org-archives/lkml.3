Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbaISLVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:21:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54259 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaISLVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:21:41 -0400
Date: Fri, 19 Sep 2014 13:21:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Amit Pundir <amit.pundir@linaro.org>
Cc: linux-kernel@vger.kernel.org, Todd Poynor <toddpoynor@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH v2] PM: Print pending wakeup IRQ preventing suspend
Message-ID: <20140919112137.GA13233@amd>
References: <1411082555-4425-1-git-send-email-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411082555-4425-1-git-send-email-amit.pundir@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-09-19 04:52:35, Amit Pundir wrote:
> From: Todd Poynor <toddpoynor@google.com>
> 
> Currently when a pending wakeup irq stops suspend, it can be difficult
> to determine why suspend was prevented and which IRQ was actually
> responsible. In order to help debug such situation, this patch prints the
> IRQ number and action name of that pending wakeup irq.
> 

Acked-by: Pavel Machek <pavel@ucw.cz>
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
