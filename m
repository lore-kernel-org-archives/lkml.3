Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbaI2OEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:04:13 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:39662 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbaI2OEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:04:10 -0400
Date: Mon, 29 Sep 2014 10:04:01 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] AHCI: Move host activation code into ahci_host_activate()
Message-ID: <20140929140401.GA15925@htj.dyndns.org>
References: <cover.1411648623.git.agordeev@redhat.com>
 <39cff5287f4fcc33d0f00f89cb2337c5a5ec22b6.1411648623.git.agordeev@redhat.com>
 <20140928160408.GA8050@mtj.dyndns.org>
 <20140929101846.GA8971@agordeev.usersys.redhat.com>
 <20140929101948.GB8971@agordeev.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929101948.GB8971@agordeev.usersys.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 11:19:49AM +0100, Alexander Gordeev wrote:
> Currently host activation done by calling either function
> ahci_host_activate() or ata_host_activate(). Consolidate
> the code by only calling ahci_host_activate() for all AHCI
> devices.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: linux-ide@vger.kernel.org

I reverted 2-3.  Can you please respin the patches so that code
movement is separate from other changes?

Thanks.

-- 
tejun
