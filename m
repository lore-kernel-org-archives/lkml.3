Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158Ab3JRFwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 01:52:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab3JRFwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 01:52:09 -0400
Message-ID: <5260CC87.4050503@suse.de>
Date: Fri, 18 Oct 2013 07:52:07 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mike Miller <mike.miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        LKML-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] remove cpqarray from mainline kernel
References: <20131017175226.GA31535@thumper.usa.hp.com>
In-Reply-To: <20131017175226.GA31535@thumper.usa.hp.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2013 07:52 PM, Mike Miller wrote:
> From: Mike Miller <mike.miller@hp.com>
> 
> cpqarray hasn't been used in over 12 years. It's doubtful that anyone still
> uses the board. It's time the driver was removed from the mainline kernel.
> The only updates these days are minor and mostly done by people outside of HP.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
Finally.

All thumbs up for this.

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
