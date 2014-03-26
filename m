Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbaCZTcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 15:32:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:12591 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbaCZTcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 15:32:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,737,1389772800"; 
   d="scan'208";a="508229464"
From: Andi Kleen <andi@firstfloor.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Add initcall_blacklist kernel parameter
References: <1395842441-17923-1-git-send-email-prarit@redhat.com>
Date: Wed, 26 Mar 2014 12:31:40 -0700
In-Reply-To: <1395842441-17923-1-git-send-email-prarit@redhat.com> (Prarit
	Bhargava's message of "Wed, 26 Mar 2014 10:00:41 -0400")
Message-ID: <87ppl8oixv.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prarit Bhargava <prarit@redhat.com> writes:
>  core_param(initcall_debug, initcall_debug, bool, 0644);
>  
> +static char blacklist_buf[128] = "\0";

__initdata


> +static int initcall_blacklist(char *str)

__init

Rest looks good. Should be quite useful to have this option

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
