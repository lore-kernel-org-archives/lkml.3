Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbaIRJtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 05:49:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755987AbaIRJtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 05:49:24 -0400
Date: Thu, 18 Sep 2014 10:58:27 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 0/5] AHCI: Optimize interrupt processing
Message-ID: <20140918095826.GA11694@agordeev.usersys.redhat.com>
References: <cover.1410965518.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1410965518.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 05:41:44PM +0200, Alexander Gordeev wrote:
> Hello,
> 
> As per Tejun's feedback I am sending v2.

This should have been v3, not v2.
Please, disregard this series if you see it.

Thanks!

> Changes since v1:
>   - single patch split in a series of 5;
>   - changelog for patch 5 reworded;
> 
> Cc: linux-ide@vger.kernel.org
> 
> Alexander Gordeev (5):
>   AHCI: Cleanup checking of multiple MSIs/SLM modes
>   AHCI: Move host activation code into ahci_host_activate()
>   AHCI: Make some function names more descriptive
>   AHCI: Get rid of a redundant parameter to a function
>   AHCI: Optimize interrupt processing
> 
>  drivers/ata/acard-ahci.c       |  3 +-
>  drivers/ata/ahci.c             | 99 +++++++++++++++++++++++++++---------------
>  drivers/ata/ahci.h             |  8 ++--
>  drivers/ata/libahci.c          | 74 ++++++++++++++++++-------------
>  drivers/ata/libahci_platform.c |  3 +-
>  5 files changed, 114 insertions(+), 73 deletions(-)
> 
> -- 
> 1.8.3.1
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
