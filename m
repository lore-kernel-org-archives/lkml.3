Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaI2OKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:10:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34557 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454AbaI2OKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:10:32 -0400
Message-ID: <54296856.2020104@suse.de>
Date: Mon, 29 Sep 2014 16:10:30 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: James Bottomley <jbottomley@parallels.com>,
        Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        Robert Elliott <elliott@hp.com>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 33/38] libata: use __scsi_print_command()
References: <1411991947-130166-1-git-send-email-hare@suse.de> <1411991947-130166-34-git-send-email-hare@suse.de> <20140929140606.GB15925@htj.dyndns.org>
In-Reply-To: <20140929140606.GB15925@htj.dyndns.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 04:06 PM, Tejun Heo wrote:
> On Mon, Sep 29, 2014 at 01:59:02PM +0200, Hannes Reinecke wrote:
>> libata already uses an internal buffer, so we should be using
>> __scsi_print_command() here.
>>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: linux-ide@vger.kernel.org
>> Cc: LKML <linux-kernel@vger.kernel.org>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
> 
> Applied to libata/for-3.18.
> 
> Thanks.
> 
Errm.
Nice that you did, but it sort of relies for patches 01-32 to be
applied previously.
I'd rather apply your Signed-off-by: to the patch and have it
routed through the SCSI tree; that way we're sure it'll only be
applied if the previous patches are in.

Can you please pull it from libata to avoid build issues?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
