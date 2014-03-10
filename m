Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbaCJKP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:15:57 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:3293 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbaCJKPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:15:55 -0400
X-IronPort-AV: E=Sophos;i="4.97,622,1389744000"; 
   d="scan'208";a="108258033"
Date: Mon, 10 Mar 2014 10:15:53 +0000
From: Wei Liu <wei.liu2@citrix.com>
To: David Miller <davem@davemloft.net>
CC: <zoltan.kiss@citrix.com>, <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>,
        <andrew.bennieston@citrix.com>
Subject: Re: [PATCH net-next v7 0/9] xen-netback: TX grant mapping with
 SKBTX_DEV_ZEROCOPY instead of copy
Message-ID: <20140310101553.GO19620@zion.uk.xensource.com>
References: <1394142511-14827-1-git-send-email-zoltan.kiss@citrix.com>
 <20140307.160552.282750558679341658.davem@davemloft.net>
 <531B2B3E.5050800@citrix.com>
 <20140308.185759.494043114567727021.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140308.185759.494043114567727021.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2014 at 06:57:59PM -0500, David Miller wrote:
> From: Zoltan Kiss <zoltan.kiss@citrix.com>
> Date: Sat, 8 Mar 2014 14:37:50 +0000
> 
> > Maybe you mixed up mine with that? But that's also not eligible to be
> > applied yet.
> 
> I can always revert the series if there are major objections.

David, I appreciate your speed, but can you revert this series first. I
think this series still needs to undergo review. I believe Ian still
wants to have a look at it but he's travelling at the moment.

Wei.
