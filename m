Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab3CZTO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:14:56 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:46573 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab3CZTOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:14:55 -0400
Date: Tue, 26 Mar 2013 20:14:44 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH 0/8] Move ntp state to be protected by timekeeping lock
Message-ID: <20130326191443.GD2494@netboy.at.omicron.at>
References: <1364242098-5977-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364242098-5977-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 01:08:10PM -0700, John Stultz wrote:

> This patchset makes the lock ownership lines less obvious, but I've
> been sure to keep the ntp state static to ntp.c and instead provided
> some accessors via ntp-internal.h that timekeping code can use to
> make changes.  The only really ugly part is that do_adjtimex() has
> to split some of the logic between timekeeping.c and ntp.c in order
> to really get the locking done correctly.

I didn't find this too ugly or troublesome. The reshuffling you have
here looks straightforward to me.

Thanks,
Richard
