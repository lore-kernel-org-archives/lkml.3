Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaHRJQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:16:51 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:52909 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaHRJQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:16:49 -0400
Date: Mon, 18 Aug 2014 11:16:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: akpm@linux-foundation.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Ulrich Obergfell <uobergfe@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 4/5] watchdog: control hard lockup detection default
Message-ID: <20140818091644.GE25495@gmail.com>
References: <1407768567-171794-1-git-send-email-dzickus@redhat.com>
 <1407768567-171794-5-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407768567-171794-5-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> The running kernel still has the ability to enable/disable at any
> time with /proc/sys/kernel/nmi_watchdog us usual. However even
> when the default has been overridden /proc/sys/kernel/nmi_watchdog
> will initially show '1'. To truly turn it on one must disable/enable
> it, i.e.
>   echo 0 > /proc/sys/kernel/nmi_watchdog
>   echo 1 > /proc/sys/kernel/nmi_watchdog

This looks like a bug, why is this so?

Thanks,

	Ingo
