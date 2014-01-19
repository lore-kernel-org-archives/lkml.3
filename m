Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaASDul (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 22:50:41 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:59437 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaASDui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 22:50:38 -0500
MIME-Version: 1.0
In-Reply-To: <1387499242-30364-1-git-send-email-prarit@redhat.com>
References: <1387499242-30364-1-git-send-email-prarit@redhat.com>
Date: Sat, 18 Jan 2014 22:50:37 -0500
X-Google-Sender-Auth: q5u0PBJtR6uafExE0RSonI5ZG38
Message-ID: <CAJvTdK=LuvjOphrETVkZL8a17c+tQDpD9JvHaEEw=WJrqnShjg@mail.gmail.com>
Subject: Re: [PATCH] turbostat, servers do not support uncore power register
From: Len Brown <lenb@kernel.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Kristen Carlson Accardi <kristen@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 7:27 PM, Prarit Bhargava <prarit@redhat.com> wrote:
> From the Intel Software Developer's Manual section 14.7.4,
>
> "For server platforms, PP1 domain is not supported, but its PP0 domain
> supports the MSR_PP0_PERF_STATUS interface."
>
> When I run 'turbostat ls' I see the following error:
>
> /dev/cpu/0/msr offset 0x641 read failed

Let me know if you see this when running turbostat v3.6 or later.
you can find  that version in the linux-next tree.

thanks,
Len Brown, Intel Open Source Technology Center
