Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaBDKfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 05:35:34 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:20563 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaBDKfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 05:35:25 -0500
X-IronPort-AV: E=Sophos;i="4.95,778,1384300800"; 
   d="scan'208";a="97668895"
Message-ID: <52F0C26A.30601@citrix.com>
Date: Tue, 4 Feb 2014 10:35:22 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matt Rushton <mrushton@amazon.com>, Matt Wilson <msw@amazon.com>
Subject: Re: [PATCH v2 4/4] xen-blkif: drop struct blkif_request_segment_aligned
References: <1391509575-3949-1-git-send-email-roger.pau@citrix.com> <1391509575-3949-5-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1391509575-3949-5-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/14 10:26, Roger Pau Monne wrote:
> This was wrongly introduced in commit 402b27f9, the only difference
> between blkif_request_segment_aligned and blkif_request_segment is
> that the former has a named padding, while both share the same
> memory layout.
> 
> Also correct a few minor glitches in the description, including for it
> to no longer assume PAGE_SIZE == 4096.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
