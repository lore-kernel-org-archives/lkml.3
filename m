Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaJMRmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 13:42:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:55867 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbaJMRmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 13:42:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,712,1406617200"; 
   d="scan'208";a="588161108"
Message-ID: <543C0EBE.3060702@intel.com>
Date: Mon, 13 Oct 2014 10:41:18 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Qiaowei Ren <qiaowei.ren@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
References: <1405921124-4230-1-git-send-email-qiaowei.ren@intel.com>	<1405921124-4230-9-git-send-email-qiaowei.ren@intel.com> <87lhrn2qfu.fsf@tassilo.jf.intel.com>
In-Reply-To: <87lhrn2qfu.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2014 11:09 PM, Andi Kleen wrote:
> Qiaowei Ren <qiaowei.ren@intel.com> writes:
>> This patch adds the PR_MPX_REGISTER and PR_MPX_UNREGISTER prctl()
>> commands. These commands can be used to register and unregister MPX
>> related resource on the x86 platform.
> 
> Please provide a manpage for the API. This is needed
> for proper review. Your description is far too vague.

Qiaowei, have you written this manpage yet?  I see the new patches, but
no manpage yet.
