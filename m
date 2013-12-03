Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3LCSfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:35:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab3LCSfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:35:05 -0500
Date: Tue, 3 Dec 2013 10:36:07 -0800
From: Greg KH <greg@kroah.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Veaceslav Falico <vfalico@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: update MSI attribute file documentation
Message-ID: <20131203183607.GA19504@kroah.com>
References: <20131129031419.GB5889@neilslaptop.think-freely.org>
 <20131129094137.GC3028@redhat.com>
 <20131129175336.GA6152@kroah.com>
 <CAErSpo44sQU2PbufCYF+wzpMtMPC97_FgAMQgruX9Nw3XbmL8g@mail.gmail.com>
 <20131203033712.GA8525@kroah.com>
 <CAErSpo42MJ1VkhDdJ_AM-5hsidakcE_GQzWfV9UVT36nK_5a5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo42MJ1VkhDdJ_AM-5hsidakcE_GQzWfV9UVT36nK_5a5A@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 11:23:51AM -0700, Bjorn Helgaas wrote:
> On Mon, Dec 2, 2013 at 8:37 PM, Greg KH <greg@kroah.com> wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > Now that the MSI modes are now attribute files in sysfs, not
> > subdirectories, update the documentation to reflect this.
> >
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Thanks, I'll fold this into the patch that makes the code change, if
> you don't mind.

I don't mind at all, thanks.

