Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521Ab3GPQlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:41:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938Ab3GPQlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:41:51 -0400
Date: Tue, 16 Jul 2013 09:41:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Peng Tao <bergwolf@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH-v3 00/17] staging/lustre: fix various build issues
Message-ID: <20130716164144.GA17827@kroah.com>
References: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
 <1373908589.2062.18.camel@joe-AO722>
 <20130715184030.GA17220@kroah.com>
 <20130715121357.42ef2826750909c1fc57788a@linux-foundation.org>
 <20130716000755.GC26261@kroah.com>
 <CA+a=Yy6cC9rYcmAka2652UhJFse9eVfOtfg96SiObBiwsw+zQQ@mail.gmail.com>
 <20130716063207.GB30320@kroah.com>
 <1373992455.1949.6.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373992455.1949.6.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 09:34:15AM -0700, Joe Perches wrote:
> On Mon, 2013-07-15 at 23:32 -0700, Greg Kroah-Hartman wrote:
> > I'll not apply those patches, don't worry, the shrinker stuff needs to
> > stay in Andrew's tree until it hits Linus's.
> 
> To clarify, are you going to apply these 17 patches but not
> those 5 patches in Andrew's tree?
> 

Give me some time to catch up, I have 1555 patches in my "to-apply" mbox
to dig through in the next 5 days, and I will deal with it then.

greg k-h
