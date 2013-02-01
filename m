Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3BAHPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 02:15:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:32933 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab3BAHPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 02:15:37 -0500
Date: Fri, 1 Feb 2013 08:17:33 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: devel@driverdev.osuosl.org, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [PATCH] drivers: android: Restructure code in lowmemorykiller
Message-ID: <20130201071733.GA1180@kroah.com>
References: <510AE2D6.6010101@semaphore.gr>
 <20130131222511.GA21654@kroah.com>
 <510AF4B0.7090002@semaphore.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510AF4B0.7090002@semaphore.gr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 12:48:16AM +0200, Stratos Karafotis wrote:
> On 02/01/2013 12:25 AM, Greg Kroah-Hartman wrote:
> >Given that no one is working on it, why does it need to be maintained
> >easier?  :)
> 
> Thanks for your immediate response.
> I was thinking to work on this driver. Is it going to be obsolete or
> something?

The goal is to work with the mm developers and get it merged into the
proper place in the kernel.  It will take some work getting the proper
hooks into the core memory subsystem first.

I thought someone was working on it a long time ago, but it looks like
it has stalled.  You should ask on the linux-mm mailing list about it if
you are interested.

greg k-h
