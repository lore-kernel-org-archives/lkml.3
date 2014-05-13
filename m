Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965149AbaEMPHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:07:41 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:53013 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760170AbaEMPHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:07:39 -0400
Date: Tue, 13 May 2014 17:07:31 +0200
From: Michael Mueller <mimu@linux.vnet.ibm.com>
To: Romain Francoise <romain@orebokech.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        cornelia.huck@de.ibm.com, ddongch@cn.ibm.com
Subject: Re: [PATCH v1] vhost: avoid large order allocations
Message-ID: <20140513170731.181cc4e3@bee>
In-Reply-To: <87tx8tg3a1.fsf@kima.orebokech.com>
References: <1399970133-46783-1-git-send-email-mimu@linux.vnet.ibm.com>
	<1399970133-46783-2-git-send-email-mimu@linux.vnet.ibm.com>
	<20140513084049.GE29442@redhat.com>
	<87tx8tg3a1.fsf@kima.orebokech.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051315-8372-0000-0000-000009A999CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014 16:29:58 +0200
Romain Francoise <romain@orebokech.com> wrote:

> "Michael S. Tsirkin" <mst@redhat.com> writes:
> 
> > Please dont' do this, extra indirection hurts performance.
> > Instead, please change vhost_net_open and scsi to allocate the whole
> > structure with vmalloc if kmalloc fails, along the lines of
> > 74d332c13b2148ae934ea94dac1745ae92efe8e5
> 
> Back in January 2013, you didn't seem to think it was a good idea:
> 
> https://lkml.org/lkml/2013/1/23/492
> 

Hi Romain,

in that case I'd suggest that you submit your patch, ours will look pretty much the same!

Cheers
Michael

