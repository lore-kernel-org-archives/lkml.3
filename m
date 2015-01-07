Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbbAGPck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:32:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbbAGPcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:32:39 -0500
Date: Wed, 7 Jan 2015 07:32:38 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: stable 3.14 backport request for ARC
Message-ID: <20150107153238.GA3524@kroah.com>
References: <C2D7FE5348E1B147BCA15975FBA2307565BC9324@IN01WEMBXA.internal.synopsys.com>
 <54ACEE83.10105@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54ACEE83.10105@synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 01:59:55PM +0530, Vineet Gupta wrote:
> Hi Greg,
> 
> On Tuesday 23 December 2014 01:38 PM, Vineet Gupta wrote:
> > Hi,
> > 
> > Can you please backport the following mainline commits to 3.14 stable.
> > 
> > 2014-02-07 ec7ac6afd07b ARC: switch to generic ENTRY/END assembler annotations 
> > 2014-04-18 64ee9f32c33c ARC: Delete stale barrier.h 
> > 
> > 
> > Thx,
> > -Vineet
> 
> It seems above request fell thru the cracks due to holiday season.
> Can you please queue up above for next 3.14 stable cycle.
> 
> and also the following:
> 
> 2014-06-24 ba25915fb2cd ARC: Fix build breakage for !CONFIG_ARC_DW2_UNWIND
> 2014-10-01 e8ef060b37c2 ARC: [nsimosci] move peripherals to match model to FPGA

Lots of things "fell through", I have over 300 pending patches that
didn't make it into this round of kernel releases, so you are in good
company.  Just relax, they will make it in eventually :)

thanks,

greg k-h
