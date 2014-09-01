Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbaIAOAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:00:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:20511 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbaIAOAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:00:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,442,1406617200"; 
   d="scan'208";a="566621609"
Message-ID: <1409580006.30155.62.camel@linux.intel.com>
Subject: Re: [PATCH v1 1/5] mfd: lpc_sch: reduce duplicate code
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Date: Mon, 01 Sep 2014 17:00:06 +0300
In-Reply-To: <20140901134610.GB8796@lee--X1>
References: <1408705096-31286-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1408705096-31286-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20140901091317.GG7374@lee--X1> <1409566903.30155.47.camel@linux.intel.com>
	 <20140901113805.GO7374@lee--X1> <1409572101.30155.59.camel@linux.intel.com>
	 <20140901134610.GB8796@lee--X1>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-01 at 14:46 +0100, Lee Jones wrote:

[]

> > Okay, what about 1 — IP is present and we have no error, 0 — no ip, no
> > error, -err — error that should be returned, would it work for you?
> 
> I would suggest -E<error_message> for messages to be passed back, 0
> for 'everything found and correct' and >0 (#defined of course) for any
> local messages you wish to pass 'IP not found', etc.
> 
> > > #define LCP_SKIP_RESOURCE /* Seems resonable? */

Okay, makes sense. Will do this in v2.


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

