Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbaDWTW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:22:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32302 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaDWTW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:22:28 -0400
Date: Wed, 23 Apr 2014 22:21:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bastien Armand <armand.bastien@laposte.net>
Cc: devel@driverdev.osuosl.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>, linux-kernel@vger.kernel.org,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jake Champlin <jake.champlin.27@gmail.com>
Subject: Re: [PATCH v2 2/2] staging: panel: fix sparse warnings in lcd_write
Message-ID: <20140423192153.GZ26890@mwanda>
References: <20140418161057.GC1258@plop.dartybox.com>
 <20140422100144.GE26890@mwanda>
 <20140423173435.GB10879@plop.dartybox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423173435.GB10879@plop.dartybox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 07:35:02PM +0200, Bastien Armand wrote:
> On Tue, Apr 22, 2014 at 01:01:45PM +0300, Dan Carpenter wrote:
> The aim of my patch was basically to add __user annotation. I tried to
> keep the change minimal to lessen the risk of regression

Yes.  That's the right approach.  These comments are just a free bonus
in case you want to do more work on this.  Or you can ignore if you
don't want to.  It's not something you introduced so it's not your
responsibility.

regards,
dan carpenter

