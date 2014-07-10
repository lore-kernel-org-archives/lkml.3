Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaGJPxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 11:53:45 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41054 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbaGJPxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 11:53:43 -0400
Date: Thu, 10 Jul 2014 16:52:25 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Matwey V. Kornilov" <matwey@sai.msu.ru>, linux-kernel@vger.kernel.org,
        linux-parport@lists.infradead.org, hsommer@eso.org,
        matwey.kornilov@gmail.com
Subject: Re: [PATCHv3 2/2] Add force_epp module option for parport_pc.
Message-ID: <20140710165225.0991f478@alan.etchedpixels.co.uk>
In-Reply-To: <20140709212910.GB26562@kroah.com>
References: <alpine.LRH.2.00.1407071101060.3492@lnfm1.sai.msu.ru>
	<20140709212910.GB26562@kroah.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> module parameters are horrid, how is someone supposed to know to use
> this?  Why can't we "fix" the detection logic?  You just now broke
> systems that were working by forcing them to now set a module option
> where previously they didn't, so I can't take these patches as-is,
> sorry.

Can we not just add "if the CPU is PPro or higher than all is fine" ? to
the test ?

Alan
