Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaI2OGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:06:14 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:52310 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaI2OGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:06:11 -0400
Date: Mon, 29 Sep 2014 10:06:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>,
        Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        Robert Elliott <elliott@hp.com>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 33/38] libata: use __scsi_print_command()
Message-ID: <20140929140606.GB15925@htj.dyndns.org>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
 <1411991947-130166-34-git-send-email-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411991947-130166-34-git-send-email-hare@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 01:59:02PM +0200, Hannes Reinecke wrote:
> libata already uses an internal buffer, so we should be using
> __scsi_print_command() here.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: linux-ide@vger.kernel.org
> Cc: LKML <linux-kernel@vger.kernel.org>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Applied to libata/for-3.18.

Thanks.

-- 
tejun
