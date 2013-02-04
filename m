Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab3BDXrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:47:09 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:54798 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab3BDXrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:47:07 -0500
Date: Mon, 4 Feb 2013 15:49:16 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Kurachkin Michail <Michail.Kurachkin@promwad.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>
Subject: Re: TDM bus support in Linux Kernel [PATCH]
Message-ID: <20130204234916.GB11239@kroah.com>
References: <F7F628C32E67B04DAECC5CA53521253E5FAB15CE@sv-exmb01-lo1.promwad.corp>
 <511044C9.9090809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511044C9.9090809@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 10:31:21AM +1100, Ryan Mallon wrote:
> On 30/01/13 23:37, Kurachkin Michail wrote:
> > Hi Greg,
> >
> > I followed your recommendations and created a diff using Linux 3.8-rc5 sources. Please review it and give your comments.
> >
> >
> 
> Hi Kurachkin,
> 
> Below is a quick skim-through review (of about 70% of the code). I've
> not really commented on the design, mostly just on coding style and
> small bugs. For patch-sets of this size, can you please break them down
> into multiple small patches, and please post patches inline which make
> reviewing easier.

Those types of changes can all be done after the code is in the
drivers/staging/ tree, and are not a barrier for acceptance at this
point in time.

thanks,

greg k-h
