Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaGJRIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 13:08:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaGJRId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 13:08:33 -0400
Date: Thu, 10 Jul 2014 10:08:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "Matwey V. Kornilov" <matwey@sai.msu.ru>, linux-kernel@vger.kernel.org,
        linux-parport@lists.infradead.org, hsommer@eso.org,
        matwey.kornilov@gmail.com
Subject: Re: [PATCHv3 2/2] Add force_epp module option for parport_pc.
Message-ID: <20140710170813.GA23544@kroah.com>
References: <alpine.LRH.2.00.1407071101060.3492@lnfm1.sai.msu.ru>
 <20140709212910.GB26562@kroah.com>
 <20140710165225.0991f478@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140710165225.0991f478@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 04:52:25PM +0100, One Thousand Gnomes wrote:
> > module parameters are horrid, how is someone supposed to know to use
> > this?  Why can't we "fix" the detection logic?  You just now broke
> > systems that were working by forcing them to now set a module option
> > where previously they didn't, so I can't take these patches as-is,
> > sorry.
> 
> Can we not just add "if the CPU is PPro or higher than all is fine" ? to
> the test ?

That sounds reasonable to me.

greg k-h
