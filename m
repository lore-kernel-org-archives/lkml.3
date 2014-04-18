Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaDRPLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 11:11:46 -0400
Received: from smtpout2.laposte.net ([193.253.67.227]:48176 "EHLO
	smtpout.laposte.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbaDRPLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 11:11:43 -0400
Date: Fri, 18 Apr 2014 17:11:35 +0200
From: Bastien Armand <armand.bastien@laposte.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Willy Tarreau <willy@meta-x.org>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jake Champlin <jake.champlin.27@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: panel: fix sparse warnings
Message-ID: <20140418151127.GA674@plop.dartybox.com>
References: <20140418060122.GA477@plop.dartybox.com>
 <20140418061510.GA8415@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418061510.GA8415@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 11:15:10PM -0700, Greg Kroah-Hartman wrote:
> On Fri, Apr 18, 2014 at 08:01:22AM +0200, Bastien Armand wrote:
> > This patch fixes sparse warnings in panel.c.
> 
> What sparse warnings were fixed here?
> 
> It looks like you did a lot of different things, can you please break
> this out into "one patch per logical change" so it can be reviewed
> easier?
> 
> thanks,
> 
> greg k-h

Hi,

Thank you for this return. I will split this patch, document it a little
more and submit it again.

take care.
bastien
