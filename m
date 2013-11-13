Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab3KMKn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 05:43:27 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:41385 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3KMKnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 05:43:23 -0500
X-IronPort-AV: E=Sophos;i="4.93,691,1378857600"; 
   d="scan'208";a="71405609"
Message-ID: <1384339400.5406.46.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen-gnttab: do not add m2p override entries
 for blkback mappings
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Anthony Liguori <anthony@codemonkey.ws>
CC: <xen-devel@lists.xen.org>, Anthony Liguori <aliguori@amazon.com>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        <linux-kernel@vger.kernel.org>, David Vrabel <david.vrabel@citrix.com>,
        "Matt Wilson" <msw@amazon.com>, Roger Pau Monne <roger.pau@citrix.com>
Date: Wed, 13 Nov 2013 10:43:20 +0000
In-Reply-To: <1384307336-5328-1-git-send-email-anthony@codemonkey.ws>
References: <1384307336-5328-1-git-send-email-anthony@codemonkey.ws>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-12 at 17:48 -0800, Anthony Liguori wrote:
> See http://article.gmane.org/gmane.linux.kernel/1590932 for a full
> analysis of current users.

Silly nit: Please can you include the message ID in case this goes away,
or use a URL which includes the ID already so it can be translated if
need be.

I think LKML has a redirector thing you can use or if it went to
xen-devel you can use http://bugs.xenproject.org/xen/mid/<message-id>

Ian.

