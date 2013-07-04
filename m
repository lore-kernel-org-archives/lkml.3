Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342Ab3GDV16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 17:27:58 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:48683 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043Ab3GDV15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 17:27:57 -0400
MIME-Version: 1.0
In-Reply-To: <1372971797-23518-1-git-send-email-artagnon@gmail.com>
References: <1372971797-23518-1-git-send-email-artagnon@gmail.com>
Date: Thu, 4 Jul 2013 23:27:56 +0200
Message-ID: <CAFLxGvyOYi8oub0WRB9j0rHr-g3zyH8k_An=A5uQa+cugQnTNw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Get defconfig to work with ARCH=um
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Thu, Jul 4, 2013 at 11:03 PM, Ramkumar Ramachandra
<artagnon@gmail.com> wrote:
> does not work on 64-bit hosts, because the build-infrastructure is
> hard-wired to pick a 32-bit defconfig when ARCH=um.  This series fixes
> the problem.
>
> [1/3] is somewhat unrelated to the series, and I happened to notice it
> while reading.  12783aa07 (um: Switch to large mcmodel on x86_64,
> 2012-01-24) indicates that I did something stupid, but I don't know
> what.

Yes, you broke kernel modules on um/x84_64.
Can you please merge 2/3 and 3/3?
Make sure that a series is always bisect-able.

--
Thanks,
//richard
