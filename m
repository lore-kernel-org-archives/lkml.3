Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab3IYXDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:03:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3IYXDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:03:15 -0400
Date: Wed, 25 Sep 2013 16:03:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: snitzer@redhat.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com,
        joe@perches.com, akpm@linux-foundation.org, dan.carpenter@oracle.com,
        ejt@redhat.com, cesarb@cesarb.net, m.chehab@samsung.com
Subject: Re: Reworking dm-writeboost [was: Re: staging: Add dm-writeboost]
Message-ID: <20130925230314.GA4802@kroah.com>
References: <5223208D.4000008@gmail.com>
 <20130916215357.GA5015@redhat.com>
 <52384E66.6050101@gmail.com>
 <20130917205936.GB12001@redhat.com>
 <523E3522.2060607@gmail.com>
 <524183A2.9050301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524183A2.9050301@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 09:20:50PM +0900, Akira Hayakawa wrote:
> Hi, Mike
> 
> I am now working on redesigning and implementation
> of dm-writeboost.

Ok, I'm dropping your original patch, please resend when you have
something you want merged into drivers/staging/

thanks,

greg k-h
