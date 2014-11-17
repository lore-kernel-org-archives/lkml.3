Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaKQUwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 15:52:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbaKQUw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 15:52:28 -0500
Message-ID: <1416257530.4494.0.camel@localhost>
Subject: Re: [PATCH 1/1] ipc/mqueue.c: Drag unneeded code out of locks
From: Davidlohr Bueso <dave@stgolabs.net>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Doug Ledford <dledford@redhat.com>, linux-newbie@vger.kernel.org
Date: Mon, 17 Nov 2014 12:52:10 -0800
In-Reply-To: <546A47C6.4030309@colorfullife.com>
References: <fae396b9bc15.545c5b55@langara.bc.ca>
	 <1415780201.24725.2.camel@linux-t7sj.site>
	 <fbb3e8aa49d6.5466da38@langara.bc.ca>
	 <1416086539.12597.15.camel@linux-t7sj.site>
	 <fb59f9ad237f.5468fdbe@langara.bc.ca> <546A47C6.4030309@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-17 at 20:08 +0100, Manfred Spraul wrote:
> Hi Steven,
> 
> On 11/16/2014 08:40 PM, Steven Stewart-Gallus wrote:
> > Finally, please don't ignore the rest of my message. Even if my patch
> > isn't that good there are lots of ways to compromise and improve it
> > such as adding tests, annotations and making it clearer.
> 
> I think you were already given ideas how to improve the patch:
> 
> a) split the patch.
> 
> b) create test cases so that you are able to check that the code still 
> behaves as it did before

Adding/improving ipc kselftests would also be very welcome.

Thanks,
Davidlohr

