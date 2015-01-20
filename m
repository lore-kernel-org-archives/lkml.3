Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbbATORP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:17:15 -0500
Received: from mga03.intel.com ([134.134.136.65]:63593 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbbATOQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:16:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442726934"
Message-ID: <1421763412.31903.70.camel@linux.intel.com>
Subject: Re: [PATCH v1 0/4] mfd: reorganize Intel drivers
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Tue, 20 Jan 2015 16:16:52 +0200
In-Reply-To: <20150120134857.GK13701@x1>
References: <1418313236-10764-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20150120134857.GK13701@x1>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-20 at 13:48 +0000, Lee Jones wrote:
> On Thu, 11 Dec 2014, Andy Shevchenko wrote:
> 
> > This patchset creates a new folder under drivers/mfd and moves there Intel
> > related drivers.
> > 
> > There is no functional change. The names of the kernel configuration variables
> > are kept the same.
> 
> Can you explain to me why you think the Intel drivers need their own
> sub-directory please?

For me it seems logical. We have many drivers related to Intel specific
SoCs (in comparison the other mfd drivers that usually named in
according to some standard chip codename) and they meanwhile have long
awkward prefixes. Moreover they could share common dependencies like
X86.

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

