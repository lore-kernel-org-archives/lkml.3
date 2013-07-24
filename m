Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3GXSCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:02:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3GXSCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:02:47 -0400
Date: Wed, 24 Jul 2013 11:02:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: devel@driverdev.osuosl.org, konrad.wilk@oracle.com,
        Cristian =?iso-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>,
        Piotr Sarna <p.sarna@partner.samsung.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        bob.liu@oracle.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH staging] zcache: fix "zcache=" kernel parameter
Message-ID: <20130724180246.GA28055@kroah.com>
References: <1954608.bCh4ljCYe6@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1954608.bCh4ljCYe6@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 07:04:14PM +0200, Bartlomiej Zolnierkiewicz wrote:
> From: Piotr Sarna <p.sarna@partner.samsung.com>
> Subject: [PATCH] zcache: fix "zcache=" kernel parameter

What's with the duplicated Subject: line here?  Why?  That means the
From: line there will probably not get recognized by git (well, it
might), but then the subject is duplicated again, just like Linus has
complained about not doing in the past.

And in a mime-encoded format?  Ugh, please fix your email client and
send it again (yes, git can handle it, but it's a pain at times...)

third time's a charm?

greg k-h
