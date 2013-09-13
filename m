Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab3IMSRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:17:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763Ab3IMSRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:17:36 -0400
Date: Fri, 13 Sep 2013 20:17:20 +0200
From: Karel Zak <kzak@redhat.com>
To: Matt Porter <matt.porter@linaro.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Subject: Re: GPT detection regression in efi.c from commit 27a7c64
Message-ID: <20130913181720.GA1614@x2.net.home>
References: <20130913145033.GA8502@ohporter.com>
 <1379089736.2197.14.camel@buesod1.americas.hpqcorp.net>
 <52334506.9030802@linaro.org>
 <1379095648.2197.27.camel@buesod1.americas.hpqcorp.net>
 <523354F3.70001@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523354F3.70001@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 02:09:55PM -0400, Matt Porter wrote:
> >Come to think of it, we do have a long existing workaround: the
> >force_gpt option. Setting it will bypass any MBR checking
> >(is_pmbr_valid(), specifically).
> 
> Yes, that's what I used at first after seeing what the problem was. But then
> I opted to fix my PMBR.
> 
> I felt like it was a regression since it required a new option passed on the
> cmdline.

 Yep, it is *regression* and I guess Davidlohr is going to fix it asap :-)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
