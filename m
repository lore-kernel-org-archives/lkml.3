Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbaDHNqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:46:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:60317 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385AbaDHNqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:46:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,818,1389772800"; 
   d="scan'208";a="516678526"
Message-ID: <1396964546.26672.65.camel@sauron.fi.intel.com>
Subject: Re: [RFC/PATCH] mtd: ubi: Free peb's synchronously for fastmap
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: linux-mtd@lists.infradead.org, open list <linux-kernel@vger.kernel.org>
Date: Tue, 08 Apr 2014 16:42:26 +0300
In-Reply-To: <1396339305-16005-1-git-send-email-tlinder@codeaurora.org>
References: <1396339305-16005-1-git-send-email-tlinder@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 11:01 +0300, Tanya Brokhman wrote:
> At first mount it's possible that there are not enough free PEBs since
> there are PEB's pending to be erased. In such scenario, fm_pool (which is
> the pool from which user required PEBs are allocated) will be empty.
> Try fixing the above described situation by synchronously performing
> pending erase work, thus produce another free PEB.
> 
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

Pushed to linux-ubifs.git / master, thanks!

-- 
Best Regards,
Artem Bityutskiy

