Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbaGUGKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:10:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:51484 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbaGUGKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:10:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="564768502"
From: Andi Kleen <andi@firstfloor.org>
To: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER, PR_MPX_UNREGISTER
References: <1405921124-4230-1-git-send-email-qiaowei.ren@intel.com>
	<1405921124-4230-9-git-send-email-qiaowei.ren@intel.com>
Date: Sun, 20 Jul 2014 23:09:41 -0700
In-Reply-To: <1405921124-4230-9-git-send-email-qiaowei.ren@intel.com> (Qiaowei
	Ren's message of "Mon, 21 Jul 2014 13:38:42 +0800")
Message-ID: <87lhrn2qfu.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Qiaowei Ren <qiaowei.ren@intel.com> writes:

> This patch adds the PR_MPX_REGISTER and PR_MPX_UNREGISTER prctl()
> commands. These commands can be used to register and unregister MPX
> related resource on the x86 platform.

Please provide a manpage for the API. This is needed
for proper review. Your description is far too vague.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
