Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab3GJGLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 02:11:03 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53478 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751982Ab3GJGLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 02:11:01 -0400
Message-ID: <1373436657.7970.1.camel@dabdike>
Subject: Re: [PATCH 0/3] [SCSI] megaraid: Remove local (struct pci_dev)
 pdev's
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: adam radford <aradford@gmail.com>
Cc: Myron Stowe <myron.stowe@redhat.com>,
        Neela Syam Kolli <megaraidlinux@lsi.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 10 Jul 2013 07:10:57 +0100
In-Reply-To: <CAHtARFHbEz8UQUjh5cPSFYDxqW93EmFz7aiQ=91hfkDj0fCWdQ@mail.gmail.com>
References: <20130709203927.31676.35169.stgit@amt.stowe>
	 <1373404695.18560.17.camel@dabdike>
	 <CAHtARFHbEz8UQUjh5cPSFYDxqW93EmFz7aiQ=91hfkDj0fCWdQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-09 at 15:12 -0700, adam radford wrote:
> On Tue, Jul 9, 2013 at 2:18 PM, James Bottomley
> > Adam, you do drive by coding on this for LSI ... ack or reject, please.

> I have just now located my box of MegaRAID Parallel SCSI controllers.
> I will review and test the patch series from Myron and respond by next Monday.

Thanks,

James


