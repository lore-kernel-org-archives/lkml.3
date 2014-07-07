Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaGGLAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 07:00:05 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64346 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752590AbaGGLAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 07:00:01 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [UPDATE PATCH v2 0/6] ACPI/EC: Critical race fixes.
Date: Mon, 07 Jul 2014 13:18:04 +0200
Message-ID: <39044838.0k25m70bcR@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <cover.1404700569.git.lv.zheng@intel.com>
References: <cover.1402792240.git.lv.zheng@intel.com> <cover.1404700569.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 07, 2014 11:09:49 AM Lv Zheng wrote:
> History:
> v1:
>  The collection of bug-fixes from kernel bugzilla bug 70891.
> v2:
>  1. Improves the patch descriptions to make the root cause of the 70891 bug
>     more correct.
>  2. Improves a race fix to make it more robust.
> v2 UPDATE:
>  Added "Reported-by" and "Tested-by" from kernel bugzilla bug 59911/63931
>  as a result of EC bug triage. Only patch descriptions are updated.

OK, I've updated the commits in my tree in accordance with this.

>  Removed the GPE fix, it is included by another GPE API fix series.

I've applied it separately already, so please don't resend it.

Thanks,
Rafael

