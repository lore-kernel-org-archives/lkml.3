Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaANHHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 02:07:20 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:59062 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaANHHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 02:07:17 -0500
Date: Tue, 14 Jan 2014 08:07:11 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH] [RFC] timekeeping: Rework frequency adjustments to work
 better w/ nohz
Message-ID: <20140114070711.GA4415@netboy>
References: <1389067023-13541-1-git-send-email-john.stultz@linaro.org>
 <20140113175114.GA4271@netboy>
 <52D42D36.1020400@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D42D36.1020400@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 10:15:18AM -0800, John Stultz wrote:
> That's great to hear! Thanks so much, I really appreciate the testing!
> And this is with HZ=?

HZ=1000
 
> If you do get a chance to look again, I'd also be interested if running
> with nohz=off w/ the fix doesn't show any regression compared to the
> unmodified nohz=off case.

Okay, will do.
 
Thanks,
Richard
