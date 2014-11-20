Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbaKTIX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:23:59 -0500
Received: from verein.lst.de ([213.95.11.211]:56319 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756492AbaKTIX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:23:58 -0500
Date: Thu, 20 Nov 2014 09:23:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: build warning after merge of the scsi tree
Message-ID: <20141120082354.GA7210@lst.de>
References: <20141118192148.1c77179c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118192148.1c77179c@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 07:21:48PM +1100, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the scsi tree, today's linux-next build (powerpc
> allyesconfig) produced this warning:
> 
> drivers/scsi/ibmvscsi/ibmvfc.c: In function 'ibmvfc_queuecommand_lck':
> drivers/scsi/ibmvscsi/ibmvfc.c:1618:5: warning: unused variable 'tag' [-Wunused-variable]
>   u8 tag[2];

Thanks Stephen, I'll take care of fixing this up.
