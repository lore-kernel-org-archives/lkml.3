Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118AbaFXEAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 00:00:23 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:62679 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbaFXEAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 00:00:22 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1406231044570.5170@nanos>
References: <tip-33ee255196f8de7407012217e5fa7897555dd034@git.kernel.org>
	<CAFTL4hyhsgiXdZN4modTAYU8G3X7RULuR-d=CzrY3gmPEZ0w8Q@mail.gmail.com>
	<alpine.DEB.2.10.1406231044570.5170@nanos>
Date: Tue, 24 Jun 2014 09:30:21 +0530
X-Google-Sender-Auth: r9_-PahhI6639kxuq3vldgNNDjk
Message-ID: <CAOh2x==3O9MLu5oJ3Y1dCDE4S3AafX_39UrjzJfX5QJWF5yfrA@mail.gmail.com>
Subject: Re: [tip:timers/core] time/timers: Move all time(r) related files
 into kernel/time
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 2:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Hrmm. No idea how that happened. I zapped your commits. Lemme redo.

Redo of merge is required for tip/master as well, as it merged the bad
branch yesterday.
