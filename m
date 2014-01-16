Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaAPACr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:02:47 -0500
Received: from smtp.citrix.com ([66.165.176.89]:18624 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbaAPACo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:02:44 -0500
X-IronPort-AV: E=Sophos;i="4.95,665,1384300800"; 
   d="scan'208";a="93308217"
Date: Thu, 16 Jan 2014 00:02:43 +0000
From: Wei Liu <wei.liu2@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v4 3/9] xen-netback: Remove old TX grant copy
 definitons and fix indentations
Message-ID: <20140116000243.GC5331@zion.uk.xensource.com>
References: <1389731995-9887-1-git-send-email-zoltan.kiss@citrix.com>
 <1389731995-9887-4-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1389731995-9887-4-git-send-email-zoltan.kiss@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 08:39:49PM +0000, Zoltan Kiss wrote:
> These became obsolate with grant mapping. I've left intentionally the
               ^ obsolete
> indentations in this way, to improve readability of previous patches.
> 
