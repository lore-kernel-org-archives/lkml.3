Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbaJWR4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:56:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbaJWR4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:56:07 -0400
Message-ID: <54494101.6010701@redhat.com>
Date: Thu, 23 Oct 2014 13:55:13 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Alex Thorlton <athorlton@sgi.com>, linux-mm@kvack.org
CC: Andrew Morton <akpm@linux-foundation.org>, Bob Liu <lliubbo@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Davydov <vdavydov@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Convert khugepaged to a task_work function
References: <1414032567-109765-1-git-send-email-athorlton@sgi.com>
In-Reply-To: <1414032567-109765-1-git-send-email-athorlton@sgi.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/22/2014 10:49 PM, Alex Thorlton wrote:

> Alex Thorlton (4): Disable khugepaged thread Add pgcollapse
> controls to task_struct Convert khugepaged scan functions to work
> with task_work Add /proc files to expose per-mm pgcollapse stats

Is it just me, or did the third patch never show up in other people's
email either?

I don't see it in my inbox, my lkml folder, my linux-mm folder, or
on lkml.org

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUSUEBAAoJEM553pKExN6DougH/0fPp5nZkQ4oF3zrbLO8Hsig
muVu1VU+fy9Hkrp5SeHCXBpZmr9d00A/U4mAIrcDPrdCKWOWfG76BF31Qf4mWKwP
IB+YSHL4X/3LDGylq06xEZ3x+dci24v8Bq+3CLjMFphKcqY7A/R2VFDF82+f25jh
AanF4V6RMRSYoUVYQYbwtyToanSGb4hUKAh6chCXHRNL9m/wNwj5tiItMVY/N852
Zk0NgofzMV9yThnPCXloEr6toRJm1NrQlLYg/q5LHxA4b62NPGlmsod7gzg88svP
Q6I8quUY72sqsvMO5NfJGMxqK11PYEfo41jO2Q3sLfaMiKg0lnSBcr+FogiovGQ=
=QNt6
-----END PGP SIGNATURE-----
