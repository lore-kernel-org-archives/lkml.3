Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaANV6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:58:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbaANV6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:58:04 -0500
Date: Tue, 14 Jan 2014 13:58:42 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Levente Kurusa <levex@linux.com>
Cc: =?utf-8?Q?Micha=C5=82?= Kwiatkowski 
	<michaelflowersky@geekingspree.com>,
        devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Cruz Bishop <cruzjbishop@gmail.com>, dan.carpenter@oracle.com
Subject: Re: [PATCH] Staging: android: fix parentheses coding style issue in
 alarm-dev.c
Message-ID: <20140114215842.GA4808@kroah.com>
References: <1389734895-2760-1-git-send-email-michaelflowersky@geekingspree.com>
 <CAAsK9AG0J_+f+DPZ-j9uYJ9gPLkxG8ZGa20Poa2rLdUvb7-F_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAsK9AG0J_+f+DPZ-j9uYJ9gPLkxG8ZGa20Poa2rLdUvb7-F_w@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 10:43:04PM +0100, Levente Kurusa wrote:
> Hello,
> 
> 2014/1/14 Michał Kwiatkowski <michaelflowersky@geekingspree.com>:
> > From: Michal Kwiatkowski <michaelflowersky@geekingspree.com>
> >
> > This is a patch to the alarm-dev.c file that removes parentheses which
> > should not appear in return statement. This error was found by the
> > checkpatch.pl tool.
> >
> > Signed-off-by: Michał Kwiatkowski <michaelflowersky@geekingspree.com>
> > --
> 
> This is like the third patch in this two week period that does the
> exact same with more or less success, and I recall one getting applied
> (I might be wrong). Anyway, this one finally looks good! :-)

You are right, it doesn't apply, Michal should have received my
rejection notice from my patch-bot already saying this.

thanks,

greg k-h
