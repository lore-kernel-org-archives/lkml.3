Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3F0MW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:22:58 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:53208 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab3F0MW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:22:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Cc: Shuah Khan <shuah.kh@samsung.com>, len.brown@intel.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH v3] power: Add warning message about incorrect system date and time after resume when pm_trace is enabled
Date: Thu, 27 Jun 2013 14:32:25 +0200
Message-ID: <1706054.BUola9D1zu@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130626231808.GB13166@amd.pavel.ucw.cz>
References: <1372285655-2450-1-git-send-email-shuah.kh@samsung.com> <20130626231808.GB13166@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 27, 2013 01:18:08 AM Pavel Machek wrote:
> On Wed 2013-06-26 16:27:35, Shuah Khan wrote:
> > pm_trace uses the system's Real Time Clock (RTC) to save the magic number.
> > Reason for this is that the RTC is the only reliably available piece of
> > hardware during resume operations where a value can be set that will
> > survive a reboot.
> > 
> > Consequence is that after a resume (even if it is successful) your system
> > clock will have a value corresponding to the magic number instead of the
> > correct date/time! It is therefore advisable to use a program like ntp-date
> > or rdate to reset the correct date/time from an external time source when
> > using this trace option.
> > 
> > There is no run-time message to warn users of the consequences of enabling
> > pm_trace. Adding a warning message to pm_trace_store() will serve as a
> > reminder to users to set the system date and time after resume.
> > 
> > Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> 
> Acked-by: Pavel Machek <pavel@ucw.cz>

Queued up for 3.11.

Thanks,
Rafael

