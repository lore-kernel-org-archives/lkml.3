Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaJTGGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 02:06:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbaJTGGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 02:06:07 -0400
Message-ID: <5444A64C.1060605@suse.de>
Date: Mon, 20 Oct 2014 08:06:04 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, Chandra Seetharaman <sekharan@us.ibm.com>,
        Mike Christie <michaelc@cs.wisc.edu>
CC: Sean Stewart <Sean.Stewart@netapp.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] scsi: handle more device handler setup/teardown in
 common code
References: <1413734404-1426-1-git-send-email-hch@lst.de> <1413734404-1426-7-git-send-email-hch@lst.de>
In-Reply-To: <1413734404-1426-7-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2014 06:00 PM, Christoph Hellwig wrote:
> Move all code to set up and tear down sdev->scsi_dh_data to common code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
