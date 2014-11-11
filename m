Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaKKNce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:32:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:23860 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbaKKNcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:32:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="605926067"
Message-ID: <1415712726.22887.173.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: Extend UBI layer debug/messaging capabilities -
 cosmetics
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: hujianyang@huawei.com, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 11 Nov 2014 15:32:06 +0200
In-Reply-To: <1415531185-2343-1-git-send-email-tlinder@codeaurora.org>
References: <1415531185-2343-1-git-send-email-tlinder@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-09 at 13:06 +0200, Tanya Brokhman wrote:
> Some cosmetic fixes to the patch "UBI: Extend UBI layer debug/messaging
> capabilities".
> 
> Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
> ---

Pushed this patch, but without the hunk which changes the printing
helpers. Thanks!

