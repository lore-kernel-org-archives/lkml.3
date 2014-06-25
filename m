Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbaFYMbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:31:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbaFYMbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:31:36 -0400
Message-ID: <53AAC123.2060303@suse.de>
Date: Wed, 25 Jun 2014 14:31:31 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>,
        linux-scsi@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] scsi: use 64-bit value for 'max_luns'
References: <1401785937-43581-1-git-send-email-hare@suse.de> <1401785937-43581-6-git-send-email-hare@suse.de> <20140625122856.GA3221@infradead.org>
In-Reply-To: <20140625122856.GA3221@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 02:28 PM, Christoph Hellwig wrote:
> On Tue, Jun 03, 2014 at 10:58:56AM +0200, Hannes Reinecke wrote:
>> Now that we're using 64-bit LUNs internally we need to increase
>> the size of max_luns to 64 bits, too.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> Reviewed-by: Christoph Hellwig <hch@infradead.org>
>> Reviewed-by: Ewan Milne <emilne@redhat.com>
>
> I just noticed that this has changes to the module param code.
> These should be split into a separate patch and be ACKed by the modules
> maintainer.  I'd still love to take the change through the SCSI tree to
> be able to get this into 3.17 easily.
>
> moduleparam changes below:
>
Guess I need to redo the patchset yet again ...
Oh well.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
