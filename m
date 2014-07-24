Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbaGXBE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 21:04:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:42849 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbaGXBE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 21:04:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,720,1400050800"; 
   d="scan'208";a="548122255"
Message-ID: <53D05BA9.1040108@intel.com>
Date: Wed, 23 Jul 2014 18:04:41 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v7 09/10] x86, mpx: cleanup unused bound tables
References: <1405921124-4230-1-git-send-email-qiaowei.ren@intel.com> <1405921124-4230-10-git-send-email-qiaowei.ren@intel.com> <53CFE4F9.3000701@intel.com> <9E0BE1322F2F2246BD820DA9FC397ADE01703006@shsmsx102.ccr.corp.intel.com>
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE01703006@shsmsx102.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2014 05:49 PM, Ren, Qiaowei wrote:
> I can check a lot of debug information when one VMA and related
> bounds tables are allocated and freed through adding a lot of print()
> like log into kernel/runtime. Do you think this is enough?

I thought the entire reason we grabbed a VM_ flag was to make it
possible to figure out without resorting to this.

