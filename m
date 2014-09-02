Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbaIBWun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 18:50:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49389 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaIBWuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 18:50:39 -0400
Date: Tue, 2 Sep 2014 15:50:57 -0700
From: Darren Hart <dvhart@infradead.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "benjamin.tissoires@redhat.com" <benjamin.tissoires@redhat.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] platform/x86: toshiba: re-enable acpi hotkeys after
 suspend to disk
Message-ID: <20140902225057.GB11195@vmdeb7>
References: <1409681059-6493-1-git-send-email-benjamin.tissoires@redhat.com>
 <1409681238.11717.4.camel@nebula.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409681238.11717.4.camel@nebula.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 06:07:19PM +0000, Matthew Garrett wrote:
> On Tue, 2014-09-02 at 14:04 -0400, Benjamin Tissoires wrote:
> 
> > we noticed this problem on a Toshiba Z40. I kind of brute-forced the thing, and
> > I ended up that calling "ENAB" was making the keys working again (rmmod/insmod 
> > the driver was sufficient, and the only command which was different from the
> > resume was this ACPI call).
> > 
> > I am really surprised some toshiba laptops do not need this, so I'd prefer that
> > an ACPI expert (Matthew???) gives its wisdom regarding that.
> 
> Looks good to me. I'd be surprised if this breaks anything.
> 
> Acked-by: Matthew Garrett <matthew.garrett@nebula.com>

Queued. Thanks.

--
Darren Hart
Intel Open Source Technology Center
