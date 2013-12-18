Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3LRTur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:50:47 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:44123 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3LRTuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:50:46 -0500
MIME-Version: 1.0
In-Reply-To: <1387394945-5704-1-git-send-email-prarit@redhat.com>
References: <1387394945-5704-1-git-send-email-prarit@redhat.com>
Date: Wed, 18 Dec 2013 11:50:45 -0800
X-Google-Sender-Auth: iiU310Ed4_kj697M9DBz5LWEmhU
Message-ID: <CA+8MBbKHZ0i0mEYLUrmWwaofvnRcxc7Dvm+w0CfZf2uQydjdjQ@mail.gmail.com>
Subject: Re: [PATCH] x86: Add check for number of available vectors before CPU
 down [v2]
From: Tony Luck <tony.luck@intel.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86-ML <x86@kernel.org>,
        Michel Lespinasse <walken@google.com>, Andi Kleen <ak@linux.intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 11:29 AM, Prarit Bhargava <prarit@redhat.com> wrote:
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=64791
>
> When a cpu is downed on a system, the irqs on the cpu are assigned to other cpus.  It is possible, however, that when a cpu is downed there aren't enough free vectors on the remaining cpus to account for the vectors from the cpu that is being downed.
>
> This results in an interesting "overflow" condition where irqs are "assigned" to a CPU but are not handled.

Looks good to me.

Acked-by: Tony Luck <tony.luck@intel.com>
