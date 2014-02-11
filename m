Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaBKBcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 20:32:19 -0500
Received: from mga14.intel.com ([143.182.124.37]:33670 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbaBKBcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 20:32:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,821,1384329600"; 
   d="scan'208";a="473125911"
Date: Tue, 11 Feb 2014 09:32:11 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        wil6210@qca.qualcomm.com, linux-pci@vger.kernel.org,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Subject: Re: [PATCH] wil6210: Fix switch operator "missing break?" warning
Message-ID: <20140211013211.GA8173@localhost>
References: <cover.1389904166.git.agordeev@redhat.com>
 <aedc9b7eb82232204a7d65b4c7d3302ba6ba3892.1389904167.git.agordeev@redhat.com>
 <20140207144639.GA10939@dhcp-26-207.brq.redhat.com>
 <3132701.EBRqRlvTI9@lx-vladimir>
 <20140210121638.GA320@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210121638.GA320@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Mon, Feb 10, 2014 at 01:16:38PM +0100, Alexander Gordeev wrote:
> On Mon, Feb 10, 2014 at 12:54:13PM +0200, Vladimir Kondratiev wrote:
> > I can't reproduce this warning. What tools used to get it?
> 
> Fengguang?

This is a smatch warning:

        http://smatch.sourceforge.net/

Thanks,
Fengguang
