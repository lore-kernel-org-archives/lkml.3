Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaIDQCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:02:39 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:55343 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbaIDQCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:02:38 -0400
Date: Thu, 4 Sep 2014 16:56:06 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: RFC: Tainting the kernel on raw I/O access
Message-ID: <20140904165606.640df107@alan.etchedpixels.co.uk>
In-Reply-To: <5407955C.3040501@intel.com>
References: <5407863B.9030608@intel.com>
	<20140903232018.17bba503@alan.etchedpixels.co.uk>
	<5407955C.3040501@intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Sep 2014 15:25:32 -0700
"H. Peter Anvin" <h.peter.anvin@intel.com> wrote:

> On 09/03/2014 03:20 PM, One Thousand Gnomes wrote:
> > 
> > If you just want some "detector bits" for bug report filtering them its
> > quite a different need to fixing "secure" boot mode. Even in the detector
> > bits case there should be an overall plan and some defined properties
> > that provide the security and which you can show should always be true.
> > 
> 
> As far as I'm concerning this is just a set of "detector bits".  My
> observation was simply that this is a *subset* of what "secure boot"
> will eventually need.

I think that observation is untrue. The only partially overap.
 
> (As far as I'm concerned, I'd be happy tainting the kernel for any
> operation that requires CAP_RAWIO, but maybe that is too extreme.)

You can't then for example format some types of disk in your data center.

Alan
