Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab3FQXfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:35:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab3FQXfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:35:37 -0400
Date: Mon, 17 Jun 2013 16:35:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, juan.david.gonzalez.cobas@cern.ch,
        cota@braap.org, siglesias@igalia.com, rob@landley.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/8] FMC: add needed headers
Message-ID: <20130617233536.GB14084@kroah.com>
References: <20130617232120.GF12984@kroah.com>
 <cover.1371018406.git.rubini@gnudd.com>
 <1d3aedf8636f4bed4ffda25e13acd853bf8e08fb.1371018406.git.rubini@gnudd.com>
 <20130617232902.GA17234@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617232902.GA17234@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 01:29:02AM +0200, Alessandro Rubini wrote:
> > Any way you can use MODULE_DEVICE_TABLE() for these devices to get
> > proper module auto-loading for your drivers?
> 
> It's the next step.

Ok, good.

> We are not doing that in our installations because it is not a trivial
> addition to running kernels -- we are plugging FMC devices in
> already-deployed kernel versions, sometimes even 2.6.24.

Ick, 2.6.24, you are brave :)

thanks,

greg k-h
