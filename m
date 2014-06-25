Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbaFYLdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:33:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36218 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbaFYLdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:33:45 -0400
Date: Wed, 25 Jun 2014 04:33:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: mpt3sas: mpt3sas_transport.c: Cleaning up
 uninitialized variables
Message-ID: <20140625113339.GA29176@infradead.org>
References: <1401628118-17506-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <00b63b2641dfe04aef4feb003e98d63c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00b63b2641dfe04aef4feb003e98d63c@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 03:11:42PM +0530, Sreekanth Reddy wrote:
> Hi James,
> 
> This Patch seem to be fine. Please consider this patch as Acked-by:
> Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

I can't really find this in any of my mailboxes.  Can you just resend it
with your next driver update?  Thanks!

