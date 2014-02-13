Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaBMUAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 15:00:49 -0500
Received: from science.horizon.com ([71.41.210.146]:21318 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751968AbaBMUAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 15:00:47 -0500
Date: 13 Feb 2014 15:00:44 -0500
Message-ID: <20140213200044.3707.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: sbsiddha@gmail.com
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
Cc: davej@redhat.com, david@fromorbit.com, hpa@zytor.com, jack@suse.cz,
        linux-kernel@vger.kernel.org, linux@horizon.com,
        maarten-baert@hotmail.com, mingo@kernel.org, nate@thatsmathematics.com,
        priikone@iki.fi, stable@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, x86@kernel.org
In-Reply-To: <BLU0-SMTP662C7668A34D62A4E193ACE29D0@phx.gbl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/14 07:56, Suresh Siddha wrote:
> Here is the second patch, which should fix the issue reported in this
> thread. Maarten, Nate, George, please give this patch a try as is and
> see if it helps address the issue you ran into.

Maarten reminded me that I should officially say it's worked for me with
no problems.

I wonder if this is also the cause of the "3.14-rc2 XFS backtrace
because irqs_disabled." problem being discussed on linux-kernel &
linux-xfs right now.

Tested-by: George Spelvin <linux@horizon.com>


