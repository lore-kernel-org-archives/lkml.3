Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaHQWp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 18:45:26 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:50210 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaHQWpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 18:45:24 -0400
Date: Sun, 17 Aug 2014 15:45:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] headers: remove fs.h from poll.h
In-Reply-To: <20140817093348.GA25122@p183.telecom.by>
Message-ID: <alpine.DEB.2.02.1408171544290.9160@chino.kir.corp.google.com>
References: <20140816233746.GA32332@p183.telecom.by> <CA+55aFw3B=USNMLdehm+hv9fVWE1yaR42a2y8udcE8QvJfbSPA@mail.gmail.com> <20140817093348.GA25122@p183.telecom.by>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2014, Alexey Dobriyan wrote:

> > Doors this actually help anything? fs.h tends to get included other ways
> > anyway, and the double inclusion protection means that the compiler doesn't
> > even spend extra time on it..
> > 
> > IOW, I'd like to see "this improves compile times by xyz" or some other
> > explanation.
> 
> This particular patch doesn't change situation because it is so small and
> removes only one header from one file.
> 
> I can send bigger patch removing fs.h from many possible places.
> 

I extensively build tested your series before and reported the single 
point of failure.  Once that's fixed and the patches have appropriate 
changelogs and signed-off-by lines then I can build test and push them for 
either Andrew or Linus.
