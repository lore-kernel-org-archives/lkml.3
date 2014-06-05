Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaFEIcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 04:32:31 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36222 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaFEIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 04:32:29 -0400
MIME-Version: 1.0
X-Originating-IP: [90.207.204.193]
In-Reply-To: <1401917658-26065-10-git-send-email-eranian@google.com>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
	<1401917658-26065-10-git-send-email-eranian@google.com>
Date: Thu, 5 Jun 2014 09:32:28 +0100
Message-ID: <CADknwL5S8QpzCAgrKHjbGTbEx7nA8L=Vu8d-UWAYCg6X25OcGw@mail.gmail.com>
Subject: Re: [PATCH 9/9] perf/x86: add syfs entry to disable HT bug workaround
From: Matt Fleming <matt@console-pimps.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, zheng.z.yan@intel.com,
        maria.n.dimakopoulou@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 June 2014 22:34, Stephane Eranian <eranian@google.com> wrote:
> From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
>
> This patch adds a sysfs entry:
>
>         /sys/devices/cpu/ht_bug_workaround
>
> to activate/deactivate the PMU HT bug workaround.
>
> To activate (activated by default):
>  # echo 1 > /sys/devices/cpu/ht_bug_workaround
>
> To deactivate:
>  # echo 0 > /sys/devices/cpu/ht_bug_workaround

If your hardware contains this erratum, why would you ever want to
disable the workaround? Providing the user with the option of turning
this off seems like a bad idea.

I suspect that users will rarely know whether they can legitimately
disable this.
