Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbaDPQrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:47:45 -0400
Received: from verein.lst.de ([213.95.11.211]:58543 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbaDPQrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:47:42 -0400
Date: Wed, 16 Apr 2014 18:47:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/8] blk-mq: bidi support
Message-ID: <20140416164739.GA19947@lst.de>
References: <1397634299-7466-1-git-send-email-hch@lst.de> <1397634299-7466-3-git-send-email-hch@lst.de> <534EB2BA.7020705@kernel.dk> <20140416164406.GA19850@lst.de> <534EB38F.7050801@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534EB38F.7050801@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 10:45:03AM -0600, Jens Axboe wrote:
> There's nothing wrong with the check, it's identical to one I sent out
> last week. But it's not part of the bidi enable patch, it's a separate
> bug fix for bsg.

Do you want to split it up while applying or should I resend two
separate patches?
