Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbaJ3JAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 05:00:23 -0400
Received: from verein.lst.de ([213.95.11.211]:41822 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbaJ3JAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 05:00:20 -0400
Date: Thu, 30 Oct 2014 10:00:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christoph Hellwig <hch@lst.de>, Chandra Seetharaman <sekharan@us.ibm.com>,
        Hannes Reinecke <hare@suse.de>, Sean Stewart <Sean.Stewart@netapp.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] scsi: handle more device handler setup/teardown in
	common code
Message-ID: <20141030090015.GA20731@lst.de>
References: <1413734404-1426-1-git-send-email-hch@lst.de> <1413734404-1426-7-git-send-email-hch@lst.de> <544FD7FC.8070005@cs.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544FD7FC.8070005@cs.wisc.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 12:53:00PM -0500, Mike Christie wrote:
> Was this supposed to return a "struct scsi_dh_data *" instead of zero here?

Yes, thanks for catching it.

