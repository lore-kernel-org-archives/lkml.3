Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbaBLQqC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:46:02 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:40303 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbaBLQqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:46:00 -0500
Date: Wed, 12 Feb 2014 08:45:57 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.13 000/120] 3.13.3-stable review
Message-ID: <20140212164557.GB19445@roeck-us.net>
References: <20140211184823.492407127@linuxfoundation.org>
 <20140212042906.GD26490@roeck-us.net>
 <20140212162728.GB21336@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212162728.GB21336@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 
> > Hmm ... not sure if I want to take that risk :-). Going to be fun.
> > And looking for volunteers to provide me with a really great test suite
> > which I can run in qemu (and which doesn't take me days to set up).
> 
> What about the new rcu test suite that has been added to the kernel
> tree?
> 
Good idea. I'll see if I can add some of those tests.

Guenter
