Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaIPVou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:44:50 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41370 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033AbaIPVos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:44:48 -0400
Message-ID: <1410903882.3840.17.camel@jarvis>
Subject: Re: [ANNOUNCE] scsi patch queue tree updated
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 16 Sep 2014 22:44:42 +0100
In-Reply-To: <20140916213739.GA19111@infradead.org>
References: <20140708134003.GA7790@infradead.org>
	 <20140801122042.GA10771@infradead.org>
	 <20140915225818.GA11869@infradead.org>
	 <20140916213739.GA19111@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-16 at 14:37 -0700, Christoph Hellwig wrote:
> On Mon, Sep 15, 2014 at 03:58:18PM -0700, Christoph Hellwig wrote:
> > I've pushed two updates to the core-for-3.17 branch of
> > 
> >     git://git.infradead.org/users/hch/scsi-queue.git
> > 
> > which should go to Linus before the next rc.
> > 
> > One is a regression fix for drivers using block layer tagging when
> > not using blk-mq introduced in the blk-mq series, and the other
> > fixes a potential buffer overrun in the iscsi initiator.
> > 
> > Updates of the for-3.18 trees will follow soon.
> 
> core-for-3.17 has grown another fix from Daniel for bidi support.

OK, I've pushed this to -next.  If nothing bad turns up I'll send it to
Linus on Friday.

James


