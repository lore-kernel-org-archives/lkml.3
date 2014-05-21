Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaEUSc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 14:32:26 -0400
Received: from p3plsmtpa09-03.prod.phx3.secureserver.net ([173.201.193.232]:49782
	"EHLO p3plsmtpa09-03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801AbaEUScZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 14:32:25 -0400
Date: Wed, 21 May 2014 11:32:20 -0700
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <anton@enomsg.org>
Subject: Re: bq24190: What's the correct API to turn boost mode (OTG) on
 for the battery charger ?
Message-ID: <20140521183220.GA29226@animalcreek.com>
References: <2044381.o3QyvTfyIx@avalon>
 <20140515220844.GA10762@animalcreek.com>
 <1782446.TpztL69o3V@avalon>
 <20140521182543.GA28477@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521182543.GA28477@animalcreek.com>
Organization: Animal Creek Technologies, Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 11:25:43AM -0700, Mark A. Greer wrote:
> On Fri, May 16, 2014 at 12:35:34AM +0200, Laurent Pinchart wrote:

> > On a side note, is there any reference userspace implementation of a battery 
> > manager ? The vendor BSP I've received with the board hardcodes calls to the 
> > bq24190 in the MUSB driver to switch between OTG and trickle charge modes 
> > based on USB cable connection/disconnection events. That's pretty ugly, and I 
> > assume this should be handled in userspace - or is there a standard kernel 
> > infrastructure for that ? 
> 
> I don't have a good feel for what's out there but the charger-manager may
> be a good place to start:
> 
> Documentation/power/charger-manager.txt
> drivers/power/charger-manager.c

And,

http://elinux.org/images/c/c6/Elce11_ham.pdf
