Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbaILAvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 20:51:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:2062 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbaILAvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 20:51:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,509,1406617200"; 
   d="scan'208";a="601757909"
Message-ID: <54124379.5090502@intel.com>
Date: Thu, 11 Sep 2014 17:51:05 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/10] Intel MPX support
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 01:46 AM, Qiaowei Ren wrote:
> MPX kernel code, namely this patchset, has mainly the 2 responsibilities:
> provide handlers for bounds faults (#BR), and manage bounds memory.

Qiaowei, We probably need to mention here what "bounds memory" is, and
why it has to be managed, and who is responsible for the different pieces.

Who allocates the memory?
Who fills the memory?
When is it freed?

Thomas, do you have any other suggestions for things you'd like to see
clarified?
