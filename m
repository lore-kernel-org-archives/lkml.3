Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321AbaLBWJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 17:09:45 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:39477 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194AbaLBWJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 17:09:41 -0500
Date: Tue, 2 Dec 2014 14:09:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Srikanth Thokala <sriku.linux@gmail.com>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: memory-barriers: Fix typo in the first
 example
Message-ID: <20141202220935.GW25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1416285598-6630-1-git-send-email-sriku.linux@gmail.com>
 <CA+mB=1+4=eG6d-99+yZ6HgpqvU2uan+-13pXt1=H+GZ0HeRL1A@mail.gmail.com>
 <20141202161519.581ea1af@lwn.net>
 <20141202215006.GT25340@linux.vnet.ibm.com>
 <20141202170136.7fb6f6a0@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141202170136.7fb6f6a0@lwn.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120222-8236-0000-0000-000007670407
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 05:01:36PM -0500, Jonathan Corbet wrote:
> On Tue, 2 Dec 2014 13:50:06 -0800
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > I am guessing that this patch is against an old version of this file
> > (there have been two patches applied to this example in the last six
> > months).  I believe that the current version is correct, in other words,
> > that Alexey Dobriyan and Pranith Kumar beat you to this one.  ;-)
> 
> I thought it looked familiar somehow...patch dropped.
> 
> I guess it's comforting to know that so many people are reading that file
> so closely, but it's a little scary too...:)

What scares me is that so few people appear to have been reading it
earlier on.  ;-)

							Thanx, Paul

