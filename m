Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaFXAKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 20:10:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:14802 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbaFXAKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 20:10:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,533,1400050800"; 
   d="scan'208";a="562173371"
Message-ID: <53A8C1EF.7030309@intel.com>
Date: Mon, 23 Jun 2014 17:10:23 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH v6 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-9-git-send-email-qiaowei.ren@intel.com> <53A8874A.3050301@mit.edu> <53A88966.5080400@intel.com> <CALCETrX7B8yxrNgojCR8YNH+6zHX8vq+GMFn0RjdWXdLmhA-Fg@mail.gmail.com> <53A8BB5A.5090103@intel.com> <CALCETrVXn5HAcifiU1TnGUckNz8g7ZEw1FeMjLwVCpd6G+pq3g@mail.gmail.com>
In-Reply-To: <CALCETrVXn5HAcifiU1TnGUckNz8g7ZEw1FeMjLwVCpd6G+pq3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 05:01 PM, Andy Lutomirski wrote:
> I suspect that the existence of the get operation matters more.  What
> if the checkpointed process has the cached copy out of sync with the
> register copy?  More realistically, what if the checkpointed process
> doesn't want to use kernel MPX assistance at all?  CRIU won't be able
> to detect this with the current proposed interface.

That's fair criticism.

Pavel, do you have any concrete suggestions on what kind of interface
would be nice for checkpoint/restart?  Or is this something you will
just tackle down the road some other way?
