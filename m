Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaHEAMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 20:12:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:11831 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbaHEAMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 20:12:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,801,1400050800"; 
   d="scan'208";a="553706167"
Date: Mon, 4 Aug 2014 17:12:37 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Nyman, Mathias" <mathias.nyman@intel.com>
Subject: Re: Kernel Debugging Support
Message-ID: <20140805001237.GA29701@xanatos>
References: <CAPDOMVj5nifG8VQBB_UzNESBc+arxpCQ5sEOAYdb6Rr-KkDSHw@mail.gmail.com>
 <20140804164633.GA28436@xanatos>
 <A2CA0424C0A6F04399FB9E1CD98E0304844C4028@US01WEMBX2.internal.synopsys.com>
 <58974.1407180184@turing-police.cc.vt.edu>
 <A2CA0424C0A6F04399FB9E1CD98E0304844C4061@US01WEMBX2.internal.synopsys.com>
 <62334.1407184063@turing-police.cc.vt.edu>
 <A2CA0424C0A6F04399FB9E1CD98E0304844C411C@US01WEMBX2.internal.synopsys.com>
 <CAPDOMViK3ZzeDhNMi9oX_s8kZG45BGPwbmZeoT4u-nqg2rgwSg@mail.gmail.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844C415A@US01WEMBX2.internal.synopsys.com>
 <CAPDOMVjy9DzNVMg__MP7-0VAXYojDuGr6v+SoNfj3hhBKyHMYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMVjy9DzNVMg__MP7-0VAXYojDuGr6v+SoNfj3hhBKyHMYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 07:11:07PM -0400, Nick Krause wrote:
> On Mon, Aug 4, 2014 at 7:03 PM, Paul Zimmerman
> <Paul.Zimmerman@synopsys.com> wrote:
> >> From: Nick Krause [mailto:xerofoify@gmail.com]

[snip]

> >> Paul ,
> >> My computer is rather old now as of Sandy Bridge days, so I probably
> >> can't test the patch
> >> on my own machine. However I will look at the code and see if I can
> >> forward port it
> >> against the usb git tree I have a current version of. In addition I
> >> would like the new xhci
> >> maintainers information in  order to send out a patch with the
> >> Maintainer for xhci updated.
> >
> > Sarah already told you who the new maintainer is, and then CCed him
> > on this thread. Hint: There is a file name 'MAINTAINERS' in the root
> > of the kernel tree, which tells you who the maintainers are for all of
> > the subsystems. Please read Documentation/SubmittingPatches, it has a
> > lot of information like this that you need to know.
> >
> > --
> > Paul
> >
> Thanks I will read this file and thanks for the information. I known
> where the file is I will
> add the information then.

You may be looking at an older version of MAINTAINERS.  Mathias has only
been marked as the maintainer since 3.15.  Which kernel version are you
working on?

Sarah Sharp
