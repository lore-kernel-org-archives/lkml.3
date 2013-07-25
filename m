Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab3GYSkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:40:37 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:43082 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499Ab3GYSic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:38:32 -0400
Date: Thu, 25 Jul 2013 21:38:25 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, whiteheadm@acm.org,
        Prashant Shah <pshah.mumbai@gmail.com>,
        Ryan Mallon <rmallon@gmail.com>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mwhitehe@redhat.com, kernel-mentors@selenic.com
Subject: Re: [PATCH] Change request_irq() to use struct net_device *dev->name
Message-ID: <20130725183824.GA32658@blackmetal.musicnaut.iki.fi>
References: <1374646199-9398-1-git-send-email-pshah.mumbai@gmail.com>
 <51F07489.7010404@gmail.com>
 <CAD6i1fJO3geZ0vkHLsJEd+KedHkpC1OZVTJJskU2RAAKYBhhJQ@mail.gmail.com>
 <CAD6i1f+NYu7rcQwF-TXk4+OdjPNZwMKxxjJ9YA_+v9B6uPYq+g@mail.gmail.com>
 <CAHp75VdouA2w5WjBPJ2cX8AKvTeCNrj6pM+3SS5DzU+ARM5M3Q@mail.gmail.com>
 <CAP8WD_aKqqB4Fb4Vadj_AJ4ET5gxd+EkaCMMVvBxxqNwDjpBGg@mail.gmail.com>
 <CAHp75VeqgqVdn+zRjW+McwFQfD73NhYz4X3M4ndeDZnkFmqyEg@mail.gmail.com>
 <51F16F74.3070503@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F16F74.3070503@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 25, 2013 at 10:33:24PM +0400, Sergei Shtylyov wrote:
>    It's also called managed device API. In fact, I've never heard it
> named devres API.

Never read the documentation. :-)

$ head -1 Documentation/driver-model/devres.txt 
Devres - Managed Device Resource

A.
