Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaJTIGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 04:06:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbaJTIGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 04:06:11 -0400
Message-ID: <5444C270.7020709@suse.de>
Date: Mon, 20 Oct 2014 10:06:08 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Mike Christie <michaelc@cs.wisc.edu>,
        Sean Stewart <Sean.Stewart@netapp.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] scsi_dh: get module reference outside of device handler
References: <1413734404-1426-1-git-send-email-hch@lst.de> <1413734404-1426-2-git-send-email-hch@lst.de> <5444A530.3080204@suse.de> <20141020065355.GA6675@lst.de>
In-Reply-To: <20141020065355.GA6675@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 08:53 AM, Christoph Hellwig wrote:
> On Mon, Oct 20, 2014 at 08:01:20AM +0200, Hannes Reinecke wrote:
>> Is it guaranteed that you cannot call ->attach() for devices which
>> already have a device_handler attached?
>> You've skipped the case
>>
>> scsi_dh != sdev->scsi_dh_data->scsi_dh
> 
> No.  Just instead of an if / else it's an if with an early return in the
> new code.
> 
right. Indeed.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
