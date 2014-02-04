Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbaBDKe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 05:34:26 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:20159 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaBDKeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 05:34:19 -0500
X-IronPort-AV: E=Sophos;i="4.95,778,1384300800"; 
   d="scan'208";a="97668226"
Message-ID: <52F0C228.2080901@citrix.com>
Date: Tue, 4 Feb 2014 10:34:16 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matt Rushton <mrushton@amazon.com>, Matt Wilson <msw@amazon.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v2 3/4] xen-blkback: fix shutdown race
References: <1391509575-3949-1-git-send-email-roger.pau@citrix.com> <1391509575-3949-4-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1391509575-3949-4-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/14 10:26, Roger Pau Monne wrote:
> Introduce a new variable to keep track of the number of in-flight
> requests. We need to make sure that when xen_blkif_put is called the
> request has already been freed and we can safely free xen_blkif, which
> was not the case before.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
