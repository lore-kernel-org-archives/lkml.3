Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab3EHPjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:39:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3EHPji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:39:38 -0400
Date: Wed, 8 May 2013 08:39:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Yuan-Hsin Chen <yuanlmm@gmail.com>, sarah.a.sharp@linux.intel.com,
        Felipe Balbi <balbi@ti.com>, Julia.Lawall@lip6.fr,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>,
        ratbert <ratbert.chuang@gmail.com>,
        John Feng-Hsin =?utf-8?B?Q2hpYW5nKOaxn+WzsOiIiCk=?= 
	<john453@faraday-tech.com>
Subject: Re: [PATCH v4] usb host: Faraday USB2.0 FUSBH200-HCD driver
Message-ID: <20130508153937.GC17186@kroah.com>
References: <CADB-Go+9SPt8A7E3FsF0TFcF-yARMYX7QDZTsZU4uNSTZWrgqw@mail.gmail.com>
 <Pine.LNX.4.44L0.1305081039250.1450-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1305081039250.1450-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 10:40:08AM -0400, Alan Stern wrote:
> On Wed, 8 May 2013, Yuan-Hsin Chen wrote:
> 
> > Hi,
> > 
> > Are there any advice?
> > Thanks.
> > 
> > On Fri, Apr 26, 2013 at 5:37 PM, Yuan-Hsin Chen <yuanlmm@gmail.com> wrote:
> > > FUSBH200-HCD is an USB2.0 hcd for Faraday FUSBH200.
> > > FUSBH200 is an ehci-like controller with some differences.
> > > First, register layout of FUSBH200 is incompatible with EHCI.
> > > Furthermore, FUSBH200 is lack of siTDs which means iTDs
> > > are used for both HS and FS ISO transfer.
> 
> As far as I'm concerned, this can be merged.

Ok, I'll queue it up after 3.10-rc1 is out.

greg k-h
