Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbaC0P2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 11:28:24 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37143 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754890AbaC0P2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 11:28:22 -0400
Message-ID: <1395934099.3718.9.camel@dabdike>
Subject: Re: [PATCH 16/39] virtio_scsi: use cmd_size
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 27 Mar 2014 08:28:19 -0700
In-Reply-To: <5331A27C.8060303@redhat.com>
References: <20140317132733.789623766@bombadil.infradead.org>
	 <20140317133133.814453025@bombadil.infradead.org>
	 <20140325153104.GA25748@infradead.org> <5331A27C.8060303@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-25 at 16:36 +0100, Paolo Bonzini wrote:
> Il 25/03/2014 16:31, Christoph Hellwig ha scritto:
> > Paolo,
> >
> > do you have a virtio_scsi tree to picks this up in?  We now have all
> > the infrastructure for it in James' tree.
> 
> I don't, I usually just give my Acked-by and James picks it up.

OK, since we have the acked by, this can go in ... there are some other
dependent patches as well, I think, could you resend those as a separate
series too, please Christoph.

James


