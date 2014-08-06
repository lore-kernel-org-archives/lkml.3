Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbaHFOc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:32:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaHFOcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:32:23 -0400
Date: Wed, 6 Aug 2014 07:31:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Michal Marek <mmarek@suse.cz>
Cc: shuah.kh@samsung.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: devtest - new make target for build all and run
 tests
Message-ID: <20140806143149.GA13552@kroah.com>
References: <1405716274-24420-1-git-send-email-shuah.kh@samsung.com>
 <53E232E6.8060506@suse.cz>
 <53E235DE.70604@samsung.com>
 <53E23669.5050309@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E23669.5050309@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 04:06:33PM +0200, Michal Marek wrote:
> On 2014-08-06 16:04, Shuah Khan wrote:
> > On 08/06/2014 07:51 AM, Michal Marek wrote:
> >> On 2014-07-18 22:44, Shuah Khan wrote:
> >>> Add a new devtest make target to enable developer testing. This
> >>> new target does full build (make all) and then runs selftests.
> >>
> >> I agree with Sam that the name is rather ambiguous, but I can't suggest
> >> a better alternative right now.
> > 
> > Does kselftest or kern_selftest sound better?
> 
> It does sound better to me than dev(ice)test, but I'm not a native
> English speaker. Greg?

Either is fine with me, but I don't think we have '_' as any make target
today, so perhaps "kselftest" is best?

thanks,

greg k-h
