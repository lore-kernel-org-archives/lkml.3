Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab3IIKSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:18:33 -0400
Received: from smtp.citrix.com ([66.165.176.89]:27873 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab3IIKSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:18:31 -0400
X-IronPort-AV: E=Sophos;i="4.90,866,1371081600"; 
   d="scan'208";a="51917267"
Message-ID: <522DA070.2060707@citrix.com>
Date: Mon, 9 Sep 2013 11:18:24 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefan.bader@canonical.com>,
        <stefano.stabellini@eu.citrix.com>, <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 2/5] xen/spinlock: We don't need the old structure anymore
References: <1378561605-18998-1-git-send-email-konrad.wilk@oracle.com> <1378561605-18998-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1378561605-18998-3-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/13 14:46, Konrad Rzeszutek Wilk wrote:
> As we are piggybacking on the generic ticketlock structs
> and these old structures are not needed anymore.

"As we are using the generic ticket lock..."

"piggybacking" suggests the Xen code isn't using a standard interface
for this.

Otherwise,

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
