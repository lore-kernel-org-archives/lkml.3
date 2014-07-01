Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbaGANt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:49:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:29664 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbaGANtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:49:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,581,1400050800"; 
   d="scan'208";a="452079742"
Message-ID: <1404222565.8366.32.camel@rzhang1-toshiba>
Subject: Re: PATCH 0/2 tmon: fix a few minor security issues
From: Zhang Rui <rui.zhang@intel.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>
Date: Tue, 01 Jul 2014 21:49:25 +0800
In-Reply-To: <20140701114249.GF7322@hmsreliant.think-freely.org>
References: <1403035509-31815-1-git-send-email-nhorman@tuxdriver.com>
	 <20140701114249.GF7322@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-01 at 07:42 -0400, Neil Horman wrote:
> On Tue, Jun 17, 2014 at 04:05:07PM -0400, Neil Horman wrote:
> > Just a few little fixups for tmon, to prevent abuse of its logging facility
> > 
> > Best
> > Neil
> > 
> Ping, Zhang, Jacob acked these, but I've not seen them go into your tree yet.
> Do you have an issue with them?
> 
Oh, next time when you send thermal related patches, please send them to
linux-pm@vger.kernel.org mailing list so that I can review the patches
in https://patchwork.kernel.org/project/linux-pm/list/

Both patches applied. Thanks!

-rui
> Neil
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 


