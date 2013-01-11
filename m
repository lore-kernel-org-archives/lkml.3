Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3AKM5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 07:57:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:15237 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab3AKM5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 07:57:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,451,1355126400"; 
   d="scan'208";a="275809088"
Date: Fri, 11 Jan 2013 13:18:02 +0000
From: Alan Cox <alan@linux.intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        gaowanlong@cn.fujitsu.com, gregkh@linuxfoundation.org,
        frank@lichtenheld.de
Subject: Re: regression, bisected: openpty fails from 3.7 onwards without
 devpts
Message-ID: <20130111131802.2986ba61@bob.linux.org.uk>
In-Reply-To: <50F00926.3070000@suse.cz>
References: <20130110144626.GA26279@breakpoint.cc>
	<20130110155058.12f66e73@bob.linux.org.uk>
	<20130110162907.GB26279@breakpoint.cc>
	<50EEF8FD.9000004@suse.cz>
	<20130110224554.1724a791@bob.linux.org.uk>
	<50EF45DF.4010905@suse.cz>
	<50EFF366.2000303@suse.cz>
	<20130111124129.GA23516@breakpoint.cc>
	<50F00926.3070000@suse.cz>
Organization: Intel
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2013 13:44:22 +0100
Jiri Slaby <jslaby@suse.cz> wrote:

> On 01/11/2013 01:41 PM, Florian Westphal wrote:
> > Jiri Slaby <jslaby@suse.cz> wrote:
> >> On 01/10/2013 11:51 PM, Jiri Slaby wrote:
> >>> On 01/10/2013 11:45 PM, Alan Cox wrote:
> >>>> So we should just fix TIOCGPTN on a pty with no suitable name
> >>>> answer to return -EINVAL
> >>>
> >>> Yes, I agree as I'm expressed in my second mail. Sorry for the
> >>> confusion.
> >>
> >> Does the attached patch help?
> > 
> > Yes, it does.  Thanks for fixing this.
> 
> Ok, now I'm not sure if we want the patch or to implement TIOCGPTN
> properly instead. Alan?

IMHO - fix now for the -rc tree where its clearly low risk, after that
whatever people feel like doing 8)

Alan
