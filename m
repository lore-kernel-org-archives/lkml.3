Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717AbaGPGUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:20:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:28211 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932966AbaGPGUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:20:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,670,1400050800"; 
   d="scan'208";a="562463170"
Message-ID: <1405491585.1829.23.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/1] fs/ubifs/super.c: replace seq_printf by seq_puts
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mtd@lists.infradead.org
Date: Wed, 16 Jul 2014 09:19:45 +0300
In-Reply-To: <1405452395-9296-1-git-send-email-fabf@skynet.be>
References: <1405452395-9296-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-15 at 21:26 +0200, Fabian Frederick wrote:
> Fix checkpatch warnings:
> "WARNING: Prefer seq_puts to seq_printf"

Applied to linux-ubifs.git, added Andrew's comments there, thanks.

-- 
Best Regards,
Artem Bityutskiy

