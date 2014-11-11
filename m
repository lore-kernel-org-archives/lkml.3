Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaKKOSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:18:43 -0500
Received: from mga14.intel.com ([192.55.52.115]:41466 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbaKKOSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:18:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414827546"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        acme@infradead.org
Subject: Re: [PATCH v6 00/14] perf: Add infrastructure and support for Intel PT
In-Reply-To: <1415705221-182873-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1415705221-182873-1-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 11 Nov 2014 16:18:36 +0200
Message-ID: <87r3x9bz2b.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Shishkin <alexander.shishkin@linux.intel.com> writes:

> Hi Peter and all,
>
> [full description below the changelog]
>
> This version of the patchset addresses comments from the previous (v5)
> version. Changes:
>
>   * dropped "bypass mask", bits that a privileged user could set in
>     RTIT_CTL,
>   * merged configuring and enabling RTIT_CTL writes,
>   * fixed kernel-doc comments
>   * if LBR/BTS events are present in the system, PT event creation is
>     disallowed and vice versa,
>   * fixed a bug with high order allocation under pressure,
>   * fixed undoing vm_locked accounting in case of AUX allocation
>     failure,
>   * replaced kref with atomic in aux refcounting,

Ouch, forgot to fold this one in, hold on for a resend. And sorry for
the noise.

Regards,
--
Alex
