Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3FZXSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:18:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55003 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3FZXSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:18:10 -0400
Date: Thu, 27 Jun 2013 01:18:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: rjw@sisk.pl, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH v3] power: Add warning message about incorrect system
 date and time after resume when pm_trace is enabled
Message-ID: <20130626231808.GB13166@amd.pavel.ucw.cz>
References: <1372285655-2450-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372285655-2450-1-git-send-email-shuah.kh@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-06-26 16:27:35, Shuah Khan wrote:
> pm_trace uses the system's Real Time Clock (RTC) to save the magic number.
> Reason for this is that the RTC is the only reliably available piece of
> hardware during resume operations where a value can be set that will
> survive a reboot.
> 
> Consequence is that after a resume (even if it is successful) your system
> clock will have a value corresponding to the magic number instead of the
> correct date/time! It is therefore advisable to use a program like ntp-date
> or rdate to reset the correct date/time from an external time source when
> using this trace option.
> 
> There is no run-time message to warn users of the consequences of enabling
> pm_trace. Adding a warning message to pm_trace_store() will serve as a
> reminder to users to set the system date and time after resume.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
