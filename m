Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973Ab3LGR4Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 12:56:24 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:64979 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758759Ab3LGR4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 12:56:22 -0500
Date: Sat, 7 Dec 2013 18:56:11 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Miroslav Lichvar <mlichvar@redhat.com>, linux-kernel@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH RFC] timekeeping: Fix clock stability with nohz
Message-ID: <20131207175610.GA7198@netboy>
References: <1384440640-9482-1-git-send-email-mlichvar@redhat.com>
 <528A7C88.1030801@linaro.org>
 <20131120183900.GA25735@localhost>
 <529D2BA6.5020005@linaro.org>
 <529D5805.20903@linaro.org>
 <20131206142602.GH22878@localhost>
 <52A27D51.1040805@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A27D51.1040805@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 05:43:45PM -0800, John Stultz wrote:
> Anyway, let me know what you think and I'll run some tests on it this
> weekend.
> 
> thanks
> -john
> 
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 3abf534..bfb36fd 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -1056,42 +1056,24 @@ static __always_inline int
> timekeeping_bigadjust(struct timekeeper *tk,
>                           s64 *offset)

John,

Any chance of posting this against a normal kernel?  I am preparing
"real" tests comparing the three different patches in this thread on
v3.12.3, but this one does not apply.

Thanks,
Richard
