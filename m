Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbaFYRBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:01:12 -0400
Received: from verein.lst.de ([213.95.11.211]:49866 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257AbaFYRBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:01:11 -0400
Date: Wed, 25 Jun 2014 19:01:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Micky Ching <micky_ching@realsil.com.cn>, Hannes Reinecke <hare@suse.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [hch-scsi-queue:core-for-3.17 18/27]
	drivers/staging/rts5208/rtsx.c:468:5: warning: format '%d' expects
	argument of type 'int', but argument 4 has type 'u64'
Message-ID: <20140625170107.GA21606@lst.de>
References: <53aaebe2.SHsdePtLmXw5IHwp%fengguang.wu@intel.com> <20140625154140.GA16179@lst.de> <20140625162322.GA8121@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140625162322.GA8121@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 12:23:22AM +0800, Fengguang Wu wrote:
> Do you mean adding rule
> 
>         if error_file =~ /drivers\/staging/
>                 TO/CC error_file's author/committer instead
>         end

Yes.

> I agree that it'd be good for Micky to work out a fix for his staging
> driver. However due to the obvious dependency here, it looks best for
> you to include the fix together with "scsi: use 64-bit LUNs"?

drivers/staging was only allowed in as long as it doesn't impact core
code and maintainers don't have to deal with the mess in there.  So
no drivers/staging/ changes should be burdened on core code.

