Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751066AbaAKXiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 18:38:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaAKXio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 18:38:44 -0500
Date: Sat, 11 Jan 2014 15:38:48 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>
Subject: Re: [char-misc 1/4] mei: do not run reset flow from the interrupt
 thread
Message-ID: <20140111233848.GB6819@kroah.com>
References: <1389205164-13553-1-git-send-email-tomas.winkler@intel.com>
 <1389205164-13553-2-git-send-email-tomas.winkler@intel.com>
 <20140108232410.GA11300@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AF40FBF@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AF40FBF@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 10:46:14PM +0000, Winkler, Tomas wrote:
> 
> 
> > 
> > This is a _really_ big patch for a stable kernel tree.  Are you sure
> > it's needed there?  Please go read Documentation/stable_kernel_rules.txt
> > again.
> 
> I understand it's big though currently I do not have significantly
> simpler fix for the issue, all 4 patches are needed to make the reset
> issue  go away.

What is the "reset issue"?  Who is it affecting?  What is the problem?
Is there a work-around without this patchset?

As it is, I can't take something this big for the stable tree, sorry.

greg k-h
