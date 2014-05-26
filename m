Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaEZUyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 16:54:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:15540 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbaEZUyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 16:54:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,914,1392192000"; 
   d="scan'208";a="545185854"
Message-ID: <5383A9D3.6030409@linux.intel.com>
Date: Mon, 26 May 2014 13:53:39 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 0/15] x86/xsaves: Optimize xstate context switch by xsaves/xrstors
References: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com> <538397F5.6010002@amacapital.net> <3E5A0FA7E9CA944F9D5414FEC6C712205A605703@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C712205A605703@ORSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2014 01:13 PM, Yu, Fenghua wrote:
> 
> So I don't see we need xsaves/xrstors in user space. But I could be
> wrong.
> 

XSAVES/XRSTORS are privileged.  The user-space equivalents are
XSAVEC/XRSTOR.

	-hpa


