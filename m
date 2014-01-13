Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaAMRhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:37:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:56423 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbaAMRhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:37:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,654,1384329600"; 
   d="scan'208";a="465948191"
From: Andi Kleen <andi@firstfloor.org>
To: Alexey Perevalov <a.perevalov@samsung.com>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, anton@enomsg.org,
        kyungmin.park@samsung.com, akpm@linux-foundation.org,
        cw00.choi@samsung.com
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
	<52D40681.3030801@samsung.com>
Date: Mon, 13 Jan 2014 09:36:42 -0800
In-Reply-To: <52D40681.3030801@samsung.com> (Alexey Perevalov's message of
	"Mon, 13 Jan 2014 19:30:09 +0400")
Message-ID: <877ga34wd1.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Perevalov <a.perevalov@samsung.com> writes:

> Hello all,
>
> one remark - timerfd is not documented in linux Documentation
> directory at all.
> I think it's better to have such description.

The documentation is the manpage in man-pages.

Ideally you change would come with the changed manpage
too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
