Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbaCTKtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 06:49:01 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:26554 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480AbaCTKs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 06:48:57 -0400
X-IronPort-AV: E=Sophos;i="4.97,694,1389744000"; 
   d="scan'208";a="111824541"
Date: Thu, 20 Mar 2014 10:48:55 +0000
From: Wei Liu <wei.liu2@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>,
        Paul Durrant <Paul.Durrant@citrix.com>
Subject: Re: [PATCH net-next v7 9/9] xen-netback: Aggregate TX unmap
 operations
Message-ID: <20140320104855.GA16285@zion.uk.xensource.com>
References: <1394142511-14827-1-git-send-email-zoltan.kiss@citrix.com>
 <1394142511-14827-10-git-send-email-zoltan.kiss@citrix.com>
 <532A0915.5090006@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <532A0915.5090006@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 09:16:05PM +0000, Zoltan Kiss wrote:
> Hi,
> 
> I'm thinking about revoking this patch: it's value is pretty small,
> but it causes performance regression on Win7 guests. And probably it
> is not the best solution for this problem. It might be the delay it
> takes the dealloc thread to be scheduled is enough.
> What do you think?
> 

Can you elaborate? What makes Win7 so special? What's performance
impact to other guests?

Wei.
