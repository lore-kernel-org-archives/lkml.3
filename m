Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162975Ab3DEWQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 18:16:50 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:50854 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162791Ab3DEWQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 18:16:48 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBbJMk2w77VGBswoYCEKQZ4HTC9jBhWun5UzGLOj15Nqrmg@mail.gmail.com>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
	<1365119186-23487-18-git-send-email-yinghai@kernel.org>
	<CA+8MBbJMk2w77VGBswoYCEKQZ4HTC9jBhWun5UzGLOj15Nqrmg@mail.gmail.com>
Date: Fri, 5 Apr 2013 15:16:48 -0700
X-Google-Sender-Auth: CkVOXUHIBU6y5UpOSSBhP0xxvf0
Message-ID: <CAE9FiQW9LsXo7gRvpAUv2ORbe2iuZaYO9nNOP-vTWa-_P450tg@mail.gmail.com>
Subject: Re: [PATCH v3 17/22] x86, ACPI, numa, ia64: split SLIT handling out
From: Yinghai Lu <yinghai@kernel.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 5, 2013 at 2:54 PM, Tony Luck <tony.luck@gmail.com> wrote:
> On Thu, Apr 4, 2013 at 4:46 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> It should not break ia64 by replacing acpi_numa_init with
>> acpi_numa_init_srat/acpi_numa_init_slit/acpi_num_arch_fixup.
>
> You are right - it doesn't break ia64.  All my test configs still
> build.  Machines both with and without NUMA still boot and
> nothing strange happens.
>
> Tested-by: Tony Luck <tony.luck@intel.com>

Great, Thanks a lot for testing them.

Yinghai
