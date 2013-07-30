Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab3G3NwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:52:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab3G3NwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:52:16 -0400
Date: Tue, 30 Jul 2013 06:53:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Piotr Sarna <p.sarna@partner.samsung.com>
Cc: ngupta@vflare.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, b.zolnierkie@samsung.com,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/2] staging: zram: add Crypto API support
Message-ID: <20130730135333.GB27962@kroah.com>
References: <1375187449-6546-1-git-send-email-p.sarna@partner.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375187449-6546-1-git-send-email-p.sarna@partner.samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 02:30:48PM +0200, Piotr Sarna wrote:
> Current version of zram does not allow any substitution of a default
> compression algorithm. Therefore, I decided to change the existing
> implementation of page compression by adding Crypto API compability.

As I have stated before, I want this code to get merged out of the
drivers/staging/ area _before_ any new features get added to it.  People
are taking too much time adding new stuff, like this, and no one seems
to be working to get it merged to the proper place anymore.

So again, I'm going to have to say no to a new feature here, sorry.
zcache, zram, and zsmalloc need to get cleaned up and merged out of
staging before anything new can be added to them.

Or, if no one is working on that, I guess I can just delete them,
right?...

thanks,

greg k-h
