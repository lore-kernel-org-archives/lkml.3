Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab3I1BDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 21:03:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42831 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754582Ab3I1BDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 21:03:37 -0400
X-Sasl-enc: Wz6FqkAMCs4U9QnrwIKhAZtLKm5q2evdIrebUIVG1yuH 1380330213
Date: Fri, 27 Sep 2013 18:04:44 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (char-misc tree related)
Message-ID: <20130928010444.GC22939@kroah.com>
References: <20130927184804.ddb460377bcd3fb35f8b41d2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130927184804.ddb460377bcd3fb35f8b41d2@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 06:48:04PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/misc/mic/card/mic_x100.c: In function 'mic_init':
> drivers/misc/mic/card/mic_x100.c:215:9: error: implicit declaration of function 'cpu_data' [-Werror=implicit-function-declaration]
>   struct cpuinfo_x86 *c = &cpu_data(0);
>          ^

<snip>

Should now be fixed, thanks.

greg k-h
