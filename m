Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbbANSdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:33:13 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39121 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbbANSdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:33:11 -0500
MIME-Version: 1.0
In-Reply-To: <1420654340-3009-1-git-send-email-john.stultz@linaro.org>
References: <1420654340-3009-1-git-send-email-john.stultz@linaro.org>
Date: Wed, 14 Jan 2015 10:33:10 -0800
Message-ID: <CALAqxLVUaMn4qgsEDDZZcmALoEbZxhhr_htFgWnCHwWYUARx4Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] time: tip/timers/urgent: Validate potential mult overflows
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 10:12 AM, John Stultz <john.stultz@linaro.org> wrote:
> Hey Ingo, Thomas,
>
>  Here are two mult overflow validation fixes from Sasha for
> tip/timers/urgent that I didn't manage to send out before the holidays.
>
> For v2 I've added the mili->micro fix Andy noticed.
>
> Let me know if you have any objections.

Thomas, Ingo,
  Just wanted to ping you here, since I've not seen any feedback here.

thanks
-john
