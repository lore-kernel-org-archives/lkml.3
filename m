Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbaDGSdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:33:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:26218 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537AbaDGSck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:32:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,811,1389772800"; 
   d="scan'208";a="488704369"
From: Andi Kleen <andi@firstfloor.org>
To: ling.ma.program@gmail.com
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, neleai@seznam.cz,
        linux-kernel@vger.kernel.org, Ling Ma <ling.ml@alibaba-inc.com>
Subject: Re: [PATCH RFC] x86:Improve memset with general 64bit instruction
References: <1396882237-27608-1-git-send-email-ling.ma@alipay.com>
Date: Mon, 07 Apr 2014 09:42:27 -0700
In-Reply-To: <1396882237-27608-1-git-send-email-ling.ma@alipay.com> (ling ma
	program's message of "Mon, 7 Apr 2014 10:50:37 -0400")
Message-ID: <877g71jdl8.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ling.ma.program@gmail.com writes:

> From: Ling Ma <ling.ml@alibaba-inc.com>
>
> In this patch we manage to reduce miss branch prediction by 
> avoiding using branch instructions and force destination to be aligned
> with general 64bit instruction. 
> Below compared results shows we improve performance up to 1.8x
> (We modified test suit from Ondra, send after this patch)

You didn't specify the CPU?

I assume it's some Atom, as nothing else uses these open coded functions
anymore?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
