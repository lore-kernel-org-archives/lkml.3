Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827AbaGCNyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:54:25 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58758 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932273AbaGCNyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:54:23 -0400
Message-ID: <1404395645.1949.2.camel@jarvis.lan>
Subject: Re: [PATCH 3.15 099/139] libiscsi, iser: Adjust data_length to
 include protection information
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>,
        Alex Williamson <alex.williamson@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        SCSI Mailing List <linux-scsi@vger.kernel.org>
Date: Thu, 03 Jul 2014 06:54:05 -0700
In-Reply-To: <20140703060548.GB17456@infradead.org>
References: <20140628174605.352098823@linuxfoundation.org>
	 <20140628174609.930049472@linuxfoundation.org>
	 <1404339330.1862.69.camel@ul30vt.home> <53B48B37.4000608@cs.wisc.edu>
	 <1404341555.16066.19.camel@dabdike> <20140703060548.GB17456@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-02 at 23:05 -0700, Christoph Hellwig wrote:
> On Wed, Jul 02, 2014 at 03:52:35PM -0700, James Bottomley wrote:
> > In which case it's not marked for stable backport ... I assume it should
> > be?
> 
> Only if the patch that regression went to stable, which it shouldn't,

Well it did:

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/scsi?h=linux-3.15.y&id=04423ddea30a7fb7232636eda8aed55ea5b972fe

The stable process is a bit broken from my point of view since it
doesn't copy linux-scsi on SCSI commits ... but this time even I didn't
get a cc, so really no-one who knew there was a problem had a chance to
comment.

The choice is either request revert from stable or add fix.

James


