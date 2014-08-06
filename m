Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbaHFIyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 04:54:14 -0400
Received: from smtp.citrix.com ([66.165.176.89]:18521 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbaHFIyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 04:54:11 -0400
X-IronPort-AV: E=Sophos;i="5.01,810,1400025600"; 
   d="scan'208";a="159209270"
Date: Wed, 6 Aug 2014 09:54:10 +0100
From: Wei Liu <wei.liu2@citrix.com>
To: David Miller <davem@davemloft.net>
CC: <wei.liu2@citrix.com>, <zoltan.kiss@citrix.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH net-next 0/2] xen-netback: Changes around carrier handling
Message-ID: <20140806085410.GA10129@zion.uk.xensource.com>
References: <1407165658-20146-1-git-send-email-zoltan.kiss@citrix.com>
 <20140805.160748.1185917042908283028.davem@davemloft.net>
 <20140806000059.GA7315@zion.uk.xensource.com>
 <20140805.185020.1023253825371873808.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140805.185020.1023253825371873808.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 06:50:20PM -0700, David Miller wrote:
> From: Wei Liu <wei.liu2@citrix.com>
> Date: Wed, 6 Aug 2014 01:00:59 +0100
> 
> > DaveM, could you please advise how to deal with this situation?
> 
> The merge window is just openning, you have two months to fix any
> problems.

OK, then I shall wait for some other incremental patches this time. But
I still prefer to get obvious issues in patches addressed before
applying them.

Wei.
