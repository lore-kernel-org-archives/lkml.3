Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbaEVLYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:24:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:55084 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbaEVLYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:24:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,886,1392192000"; 
   d="scan'208";a="543296351"
From: Andi Kleen <andi@firstfloor.org>
To: Adrien BAK <adrien.bak@numscale.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] perf tools : adds support for native scripting
References: <1400727182.19852.0.camel@desktop>
Date: Thu, 22 May 2014 04:24:11 -0700
In-Reply-To: <1400727182.19852.0.camel@desktop> (Adrien BAK's message of "Thu,
	22 May 2014 11:53:02 +0900")
Message-ID: <871tvmqco4.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrien BAK <adrien.bak@numscale.com> writes:

> As it is perf-script allows one to use perl or python scripts to parse 
> perf events.
> The following proposal aimed to introduce support of .so files as scripts.
> This support allows for better performance when parsing perf's data 
> files and a complete access to the raw data.

You'll at least need some documentation how to use it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
