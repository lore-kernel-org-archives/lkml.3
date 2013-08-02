Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab3HBPsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 11:48:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:58569 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003Ab3HBPsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 11:48:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="380853717"
Message-ID: <1375458812.14869.350.camel@sauron.fi.intel.com>
Subject: Re: [RESEND][PATCH] mtd: refactor call to request_module
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kees Cook <keescook@chromium.org>
Cc: akpm@linux-foundation.org, linux-mtd@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        James Hogan <james.hogan@imgtec.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Date: Fri, 02 Aug 2013 18:53:32 +0300
In-Reply-To: <20130708130512.GA24315@www.outflux.net>
References: <20130708130512.GA24315@www.outflux.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-08 at 06:05 -0700, Kees Cook wrote:
> This reduces the size of the stack frame when calling request_module().
> Performing the sprintf before the call is not needed.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Pushed to l2-mtd.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

