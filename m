Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaCGXoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 18:44:15 -0500
Received: from mga03.intel.com ([143.182.124.21]:64842 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbaCGXoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 18:44:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,610,1389772800"; 
   d="scan'208";a="488234922"
Date: Sat, 8 Mar 2014 07:44:11 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [x86, vdso]  BUG: unable to handle kernel paging request at
 d34bd000
Message-ID: <20140307234411.GA14886@localhost>
References: <20140307013833.GD8427@localhost>
 <1394182034.21684.6.camel@wall-e.seibold.net>
 <20140307091515.GA8888@localhost>
 <1394186248.28066.42.camel@wall-e.seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394186248.28066.42.camel@wall-e.seibold.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefani,

> So i tried my best, but without support it is impossible to find all
> issues. But mostly what i get was bureaucracy afflictions
> 
> I complied, but now it is time to help finding the issues. And not only
> do a complain, sit back and wait.

I feel sorry if that's what you perceived. But I'm just submitting
test results rather than complaining. I should actually be glad if my
test system catches more bugs. ;-) And there is no way for me to sit
back - I'm actually overloaded. Yesterday I wrote 63 emails, which is
one per 10 minutes _assuming_ I'm working 8hours. You can imagine the
works required behind all these emails.

> If i haed a  8192 core i7 XEON machine i would be able to test all
> mutations of kernels. But i have not (despite i cannot pay the invoice).
> 
> Also i get no support by people who ask me to do this work. I am really
> pissed of.

We tried hard to build the test infrastructure for the good of Linux
community. And if you like, I'd be happy to add your git tree to our
test pool - currently it already includes 300+ kernel git trees from
various developers. It'd feel more at home to find bugs in one's own
tree, rather than in the maintainers'. :-)

Thanks,
Fengguang
