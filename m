Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbaAWTKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:10:44 -0500
Received: from ext3.cumulusnetworks.com ([198.211.106.187]:47368 "EHLO
	ext3.cumulusnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaAWTKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:10:40 -0500
Date: Thu, 23 Jan 2014 11:10:36 -0800
From: Curt Brune <curt@cumulusnetworks.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Laszlo Papp <lpapp@kde.org>,
        Thomas De Schampheleire <patrickdepinguin@gmail.com>,
        gregkh@linuxfoundation.org,
        Shrijeet Mukherjee <shm@cumulusnetworks.com>, wolfram@the-dreams.de,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Add at24 based EEPROMs to the eeprom_dev hardware
 class
Message-ID: <20140123191036.GK29955@cumulusnetworks.com>
References: <CAOMwXhMVgcVVWiUYbEgGcM+K5bZmKA3LO0=jZCEsyJak1TbTSA@mail.gmail.com>
 <20140123172534.GA2665@katana>
 <CAOMwXhPqnSNWtPMo7Qrr-O3qAqtjju7au7Mudckp7kN50yQW3A@mail.gmail.com>
 <20140123181537.GA3756@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123181537.GA3756@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Jan 23 19:15, Wolfram Sang wrote:
> 
> > Well, it is not the Copyrights section, or you are saying the same
> > people should go to MODULE_AUTHOR as in the Copyrights section, even
> > if it is potentially several names? I thought this would be the name
> > of the person who put the file together even if from existing sources.
> 
> You may be right that the two can be viewed differently. Nonetheless,
> adding 10 lines to an existing driver already upstream does not count
> for both.

Apologies for the confusion resulting from a using a lot of context in
my patch.  My small changes does not warrant changing any copyright or
author notices in this file.

> 
> > >> PS.: Fixing the broken i2c mailing list typo, and updating Wolfram's
> > >> address from the broken (obsolete?) version.
> > >
> > > It came through to the i2c list? What was wrong?
> > 
> > Yes, it did, _after_ fixing the typo in the mailing list address.
> > Check the original mailing list address typed for details.
> 
> I did. That's why I asked :) Plus, since I got the original mail, it
> must have come via i2c-list since my pengutronix address was in deed
> wrong.

Again apologies:  Indeed I had the i2c-list mailing address wrong on
my initial submission, which Laszlo fixed up and resent.

I will be submitting a new version of the patch set that:

1. reduces the context lines
2. clarifies a few points in the commit message

Cheers,
Curt
