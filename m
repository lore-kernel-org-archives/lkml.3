Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826AbaGPGR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:17:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:12082 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbaGPGR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:17:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="362071893"
Message-ID: <1405491443.1829.22.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/1] fs/ubifs/super.c: replace count*size kzalloc by
 kcalloc
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>
Date: Wed, 16 Jul 2014 09:17:23 +0300
In-Reply-To: <1405491038.1829.20.camel@sauron.fi.intel.com>
References: <1403541683-10898-1-git-send-email-fabf@skynet.be>
	 <1405491038.1829.20.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 09:10 +0300, Artem Bityutskiy wrote:
> On Mon, 2014-06-23 at 18:41 +0200, Fabian Frederick wrote:
> > kcalloc manages count*sizeof overflow.
> > 
> > Cc: Artem Bityutskiy <dedekind1@gmail.com>
> > Cc: Adrian Hunter <adrian.hunter@intel.com>
> > Cc: linux-mtd@lists.infradead.org
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> 
> In the commit message, please, try to not only tell _what_ you do,
> but also _why_ you do this. And ideally, but not necessary for this
> case, I think, how this was tested (e.g., compile-tested only).

Oh, I'm sorry, you did tell "why" in this patch, I was looking an the a
different patch of yours (seq_printf). I've applied this patch to
linux-ubifs.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

