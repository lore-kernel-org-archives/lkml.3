Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbaLCA1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:27:39 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:35718 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaLCA1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:27:37 -0500
Date: Tue, 2 Dec 2014 16:27:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Srikanth Thokala <sriku.linux@gmail.com>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: memory-barriers: Fix typo in the first
 example
Message-ID: <20141203002731.GE25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1416285598-6630-1-git-send-email-sriku.linux@gmail.com>
 <CA+mB=1+4=eG6d-99+yZ6HgpqvU2uan+-13pXt1=H+GZ0HeRL1A@mail.gmail.com>
 <20141202161519.581ea1af@lwn.net>
 <20141202215006.GT25340@linux.vnet.ibm.com>
 <20141202170136.7fb6f6a0@lwn.net>
 <20141202220935.GW25340@linux.vnet.ibm.com>
 <yw1x7fy9egg9.fsf@unicorn.mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yw1x7fy9egg9.fsf@unicorn.mansr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120300-0013-0000-0000-000006B63B3D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 12:15:50AM +0000, Måns Rullgård wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> 
> > On Tue, Dec 02, 2014 at 05:01:36PM -0500, Jonathan Corbet wrote:
> >> On Tue, 2 Dec 2014 13:50:06 -0800
> >> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> >> 
> >> > I am guessing that this patch is against an old version of this file
> >> > (there have been two patches applied to this example in the last six
> >> > months).  I believe that the current version is correct, in other words,
> >> > that Alexey Dobriyan and Pranith Kumar beat you to this one.  ;-)
> >> 
> >> I thought it looked familiar somehow...patch dropped.
> >> 
> >> I guess it's comforting to know that so many people are reading that file
> >> so closely, but it's a little scary too...:)
> >
> > What scares me is that so few people appear to have been reading it
> > earlier on.  ;-)
> 
> Or they read it but failed to understand it.  Not sure which is scarier.
> 
> Those are probably the Evil Vendor Tree developers who apparently think
> "this is hard, best put volatile and barriers _everywhere_ and hope for
> the best."

"This is hard!!!  Let's go do some single-threaded programming!"  ;-)

							Thanx, Paul

