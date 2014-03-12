Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbaCLPlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:41:15 -0400
Received: from smtp.citrix.com ([66.165.176.89]:41466 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbaCLPlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:41:13 -0400
X-IronPort-AV: E=Sophos;i="4.97,639,1389744000"; 
   d="scan'208";a="110658145"
Message-ID: <1394638843.3457.11.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH net-next v7 0/9] xen-netback: TX grant mapping with
 SKBTX_DEV_ZEROCOPY instead of copy
From: Ian Campbell <Ian.Campbell@citrix.com>
To: David Miller <davem@davemloft.net>
CC: <zoltan.kiss@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>,
        <andrew.bennieston@citrix.com>
Date: Wed, 12 Mar 2014 15:40:43 +0000
In-Reply-To: <20140308.185759.494043114567727021.davem@davemloft.net>
References: <1394142511-14827-1-git-send-email-zoltan.kiss@citrix.com>
	 <20140307.160552.282750558679341658.davem@davemloft.net>
	 <531B2B3E.5050800@citrix.com>
	 <20140308.185759.494043114567727021.davem@davemloft.net>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-08 at 18:57 -0500, David Miller wrote:
> From: Zoltan Kiss <zoltan.kiss@citrix.com>
> Date: Sat, 8 Mar 2014 14:37:50 +0000
> 
> > Maybe you mixed up mine with that? But that's also not eligible to be
> > applied yet.
> 
> I can always revert the series if there are major objections.

Zoltan -- does this patch series suffer from/expose the confusion
regarding RING_HAS_UNCONSUMED_REQUESTS which we are discussing
separately on xen-devel? If the answer is yes then I think this series
should be reverted for the time being because there seems to be some
fairly fundamental questions about the semantics of that macro.

If the answer is no then I will endeavour to review this version of the
series ASAP (hopefully tomorrow) and determine if I have any other major
objections which would warrant a revert.

Ian.

