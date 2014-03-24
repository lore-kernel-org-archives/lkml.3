Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaCXKeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 06:34:31 -0400
Received: from smtp.citrix.com ([66.165.176.89]:8514 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaCXKea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 06:34:30 -0400
X-IronPort-AV: E=Sophos;i="4.97,720,1389744000"; 
   d="scan'208";a="114252960"
Message-ID: <1395657267.19365.26.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH net-next] xen-netback: Follow-up patch for grant mapping
 series
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <paul.durrant@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Date: Mon, 24 Mar 2014 10:34:27 +0000
In-Reply-To: <532C9389.4040908@citrix.com>
References: <1395343961-4744-1-git-send-email-zoltan.kiss@citrix.com>
		 <1395343961-4744-2-git-send-email-zoltan.kiss@citrix.com>
	 <1395394872.27358.11.camel@kazak.uk.xensource.com>
	 <532C9389.4040908@citrix.com>
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

On Fri, 2014-03-21 at 19:31 +0000, Zoltan Kiss wrote:
> On 21/03/14 09:41, Ian Campbell wrote:
> > On Thu, 2014-03-20 at 19:32 +0000, Zoltan Kiss wrote:
> >> Ian made some late comments about the grant mapping series, I incorporated the
> >> outcomes into this patch. Additional comments, refactoring etc.
> >
> > I don't know how davem feels about merging these kinds of thing into one
> > patch but from my point of view the least thing to do is to enumerate
> > the cleanups -- so that people can verify that the patch does infact do
> > exactly what it says it does, no more, no less.
> Ok, I'll make a detailed list in the commit message about what are the 
> changes, and fix up the typos you mentioned below.

Thanks. Also note Davem's request to split out any real changes from the
pure non-functional cleanups. 

Ian.

