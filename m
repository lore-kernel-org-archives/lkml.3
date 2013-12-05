Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab3LEVKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 16:10:54 -0500
Received: from a9-111.smtp-out.amazonses.com ([54.240.9.111]:42947 "EHLO
	a9-111.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056Ab3LEVKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 16:10:53 -0500
X-Greylist: delayed 733 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Dec 2013 16:10:52 EST
Date: Thu, 5 Dec 2013 20:58:37 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Martin Quinson <mquinson@debian.org>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Subject: quilt 0.60 does not include CCed email without name
In-Reply-To: <alpine.DEB.2.02.1312051244540.26098@gentwo.org>
Message-ID: <00000142c48e1f2a-fd398f0b-8726-4cec-a939-2c3a823bff39-000000@email.amazonses.com>
References: <20131203233232.928771708@linux.com> <20131203233250.717784556@linux.com> <1386115809.2166.126.camel@dabdike.int.hansenpartnership.com> <alpine.DEB.2.02.1312051244540.26098@gentwo.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.05-54.240.9.111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > You say this in the commit, but the linux-parisc list isn't cc'd on the
> > email ...
>
> Weird my testoutput before the patchset was sent out shows that it
> was included then :

Ok while the test output was done with quilt 0.50 the patch was actually
send with quilt 0.60 from another system. quilt 0.60 skips all Cc:s that
do not have a full name.

So Helge was included since it had a name

> Cc: Helge Deller <deller@gmx.de>

but

> Cc: linux-parisc@vger.kernel.org

did not because no name was available.

Martin?
