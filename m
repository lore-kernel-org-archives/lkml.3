Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbaIRGVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 02:21:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:24248 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757527AbaIRGVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 02:21:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,545,1406617200"; 
   d="scan'208";a="478355199"
Message-ID: <541A79CB.4040706@intel.com>
Date: Wed, 17 Sep 2014 23:20:59 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kevin Easton <kevin@guarana.org>
CC: "Ren, Qiaowei" <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com> <20140916075007.GA22076@chicago.guarana.org> <9E0BE1322F2F2246BD820DA9FC397ADE017B32C6@shsmsx102.ccr.corp.intel.com> <20140918032334.GA26560@chicago.guarana.org> <541A62DD.7080502@intel.com> <20140918071741.GA29963@chicago.guarana.org>
In-Reply-To: <20140918071741.GA29963@chicago.guarana.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2014 12:17 AM, Kevin Easton wrote:
> I was assuming that if an application did want to enable MPX after threads
> had already been created, it would generally want to enable it
> simultaneously across all threads.  This would be a lot easier for the
> kernel than for the application.

The current gcc setup mechanism would set up MPX even before main().  So
I think it's pretty unlikely that help is needed to coordinate threads.
