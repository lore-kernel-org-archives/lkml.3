Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbaBDKaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 05:30:21 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:61716 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbaBDKaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 05:30:17 -0500
X-IronPort-AV: E=Sophos;i="4.95,778,1384300800"; 
   d="scan'208";a="97666866"
Message-ID: <52F0C135.5050300@citrix.com>
Date: Tue, 4 Feb 2014 10:30:13 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        Matt Rushton <mrushton@amazon.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, <xen-devel@lists.xen.org>,
        Anthony Liguori <aliguori@amazon.com>, Matt Wilson <msw@amazon.com>
Subject: Re: [PATCH v2 1/4] xen-blkback: fix memory leak when persistent grants
 are used
References: <1391509575-3949-1-git-send-email-roger.pau@citrix.com> <1391509575-3949-2-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1391509575-3949-2-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/14 10:26, Roger Pau Monne wrote:
> From: Matt Rushton <mrushton@amazon.com>
> 
> Currently shrink_free_pagepool() is called before the pages used for
> persistent grants are released via free_persistent_gnts(). This
> results in a memory leak when a VBD that uses persistent grants is
> torn down.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
