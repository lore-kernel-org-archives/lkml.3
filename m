Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbaFYPlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:41:45 -0400
Received: from verein.lst.de ([213.95.11.211]:49607 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909AbaFYPlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:41:44 -0400
Date: Wed, 25 Jun 2014 17:41:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [hch-scsi-queue:core-for-3.17 18/27]
	drivers/staging/rts5208/rtsx.c:468:5: warning: format '%d' expects
	argument of type 'int', but argument 4 has type 'u64'
Message-ID: <20140625154140.GA16179@lst.de>
References: <53aaebe2.SHsdePtLmXw5IHwp%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53aaebe2.SHsdePtLmXw5IHwp%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang,

can you change the kbuild robot to only send warnings in the staging
drivers to the maintainers of those, and not people changing core code?

