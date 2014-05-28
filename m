Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaE1PcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:32:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbaE1PcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:32:11 -0400
Date: Wed, 28 May 2014 17:27:01 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
To: Jet Chen <jet.chen@intel.com>
Cc: tom.leiming@gmail.com, Jens Axboe <axboe@kernel.dk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [jet.chen@intel.com: [bio] kernel BUG at
 drivers/block/virtio_blk.c:166!]
Message-ID: <20140528152701.GB2255@dhcp-27-189.brq.redhat.com>
References: <20140526194347.GB2271@dhcp-27-189.brq.redhat.com>
 <CACVXFVOaF-EOioE38sy9=2f-+rKECJnzUCSHrL-VZJi1Ycj_wA@mail.gmail.com>
 <20140527084359.GD2205@dhcp-27-189.brq.redhat.com>
 <20140527112459.GF2205@dhcp-27-189.brq.redhat.com>
 <5385FDC1.2020800@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5385FDC1.2020800@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 28, 2014 at 11:16:17PM +0800, Jet Chen wrote:
> 
> Sorry for late respond. Dongsu has sent a patch for this issue.
> 	message-id <1401289778-9840-1-git-send-email-dongsu.park@profitbricks.com>
> Do you still need me to test the following patch ?

No, don't test my patch, it is not needed anymore, please test Dongsu's
patch instead so we are sure the regression is fixed.

Thanks,
Maurizio Lombardi
