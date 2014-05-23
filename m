Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248AbaEWCUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 22:20:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaEWCUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 22:20:19 -0400
Date: Fri, 23 May 2014 11:20:16 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        driverdevel <devel@driverdev.osuosl.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 00/03] staging: Emma Mobile USB driver and KZM9D board
 code
Message-ID: <20140523022016.GB27569@kroah.com>
References: <20140522085339.26279.83340.sendpatchset@w520>
 <20140522091720.GH15585@mwanda>
 <CANqRtoTaaS8UAA7UdmMFDXnZ1c71m_Poo7VY9+3fDx0Q5PAw2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANqRtoTaaS8UAA7UdmMFDXnZ1c71m_Poo7VY9+3fDx0Q5PAw2Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 06:32:03PM +0900, Magnus Damm wrote:
> Hi Dan,
> 
> On Thu, May 22, 2014 at 6:17 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > Generally we take things as is into staging so there is no need for a
> > re-work if you don't want to.  But we do need a TODO file.  Read the
> > TODO files for other staging drivers.
> 
> Thanks for pointing that out, my apologies for being random and
> skipping that! I will add a TODO file to v2!

Other than the missing TODO file, the idea looks good, I don't have any
objections to taking this.

thanks,

greg k-h
