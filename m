Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015AbaDHNrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:47:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:36778 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756974AbaDHNrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:47:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,818,1389772800"; 
   d="scan'208";a="516679660"
Message-ID: <1396964655.26672.67.camel@sauron.fi.intel.com>
Subject: Re: [RFC/PATCH] mtd: ubi: Test return value of __wl_get_peb
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: linux-mtd@lists.infradead.org, open list <linux-kernel@vger.kernel.org>
Date: Tue, 08 Apr 2014 16:44:15 +0300
In-Reply-To: <1396339273-15904-1-git-send-email-tlinder@codeaurora.org>
References: <1396339273-15904-1-git-send-email-tlinder@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 11:01 +0300, Tanya Brokhman wrote:
> In case of an error (if there are not free PEB's for example),
> __wl_get_peb will return a negative value. In order to prevent access
> violation we need to test the returned value prior to using it later on.
> 
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

Pushed to linux-ubifs.git / master, thanks!

-- 
Best Regards,
Artem Bityutskiy

