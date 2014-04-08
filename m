Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbaDHOLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:11:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:31218 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769AbaDHOLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:11:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,818,1389772800"; 
   d="scan'208";a="516887581"
Message-ID: <1396964674.26672.68.camel@sauron.fi.intel.com>
Subject: Re: [RFC/PATCH] mtd: ubi: Fix ubi free PEBs count calculation
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: linux-mtd@lists.infradead.org, open list <linux-kernel@vger.kernel.org>
Date: Tue, 08 Apr 2014 16:44:34 +0300
In-Reply-To: <1396339327-16090-1-git-send-email-tlinder@codeaurora.org>
References: <1396339327-16090-1-git-send-email-tlinder@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 11:02 +0300, Tanya Brokhman wrote:
> The ubi->free_count should be updated with every insert/remove to/from
> the ubi->free list.
> 
> Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>

Pushed to linux-ubifs.git / master, thanks!

-- 
Best Regards,
Artem Bityutskiy

