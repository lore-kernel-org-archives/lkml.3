Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484Ab3GaJul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:50:41 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:36699 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759124Ab3GaJui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:50:38 -0400
X-IronPort-AV: E=Sophos;i="4.89,786,1367971200"; 
   d="scan'208";a="7312214"
Message-ID: <51F8DDEB.603@citrix.com>
Date: Wed, 31 Jul 2013 11:50:35 +0200
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: <xen-devel@lists.xen.org>
CC: <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH RFC 0/4] xen-block: prevent blkfront for hoarding
 grants
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1373288607-1876-1-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/13 15:03, Roger Pau Monne wrote:
> The following patches prevent blkfront from hoarding all grants in the 
> system by allowing blkfront to request blkback to unmap certain grants 
> so they can be freed by blkfront. This is done periodically by 
> blkfront, unmapping a certain amount of unused persistent grants.
> 
> This series also includes a bug fix for the grant table free callback 
> implementation.

Hello,

IMHO I think 1 should go in (at the end it's a bugfix) and backported to
stable. 2 and 4 (second version) can probably also go in?

Roger.
