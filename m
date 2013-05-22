Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab3EVWWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:22:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab3EVWWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:22:05 -0400
Date: Wed, 22 May 2013 15:22:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: a.zummo@towertech.it, akpm@linuxfoundation.org, ldewangan@nvidia.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: tps6586x: device wakeup flags correction
Message-Id: <20130522152204.d46057964fa06cc0d56f8e6b@linux-foundation.org>
In-Reply-To: <1368368706-21261-1-git-send-email-digetx@gmail.com>
References: <1368368706-21261-1-git-send-email-digetx@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 May 2013 18:25:06 +0400 Dmitry Osipenko <digetx@gmail.com> wrote:

> Use device_init_wakeup() instead of device_set_wakeup_capable() and move it
> before rtc dev registering. This fixes issue with alarmtimer that checks wakeup
> capability with device_may_wakeup() on device add.

Well OK, but what is this "issue"?

(form letter: When writing a changelog, please describe the
end-user-visible effects of the bug, so that others can more easily
decide which kernel version(s) should be fixed, and so that downstream
kernel maintainers can more easily work out whether this patch will fix
a problem which they or their customers are observing.)

