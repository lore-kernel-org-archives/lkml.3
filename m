Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbaKEQaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:30:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaKEQax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:30:53 -0500
Date: Wed, 5 Nov 2014 08:29:43 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        devel@driverdev.osuosl.org, Gulsah Kose <gulsah.1004@gmail.com>,
        Jarod Wilson <jarod@wilsonet.com>, linux-kernel@vger.kernel.org,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        Matina Maria Trompouki <mtrompou@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: media: lirc: modify print calls
Message-ID: <20141105162943.GB14203@kroah.com>
References: <20141104214307.GA6709@localhost.localdomain>
 <20141105081711.4c6abcc3@recife.lan>
 <20141105134344.GB2493@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105134344.GB2493@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 03:43:44PM +0200, Aya Mahfouz wrote:
> On Wed, Nov 05, 2014 at 08:17:11AM -0200, Mauro Carvalho Chehab wrote:
> > Em Tue, 4 Nov 2014 23:43:07 +0200
> > Aya Mahfouz <mahfouz.saif.elyazal@gmail.com> escreveu:
> > 
> > > This patches replaces one pr_debug call by dev_dbg and
> > > changes the device used by one of the dev_err calls.
> > 
> > Also doesn't apply. Probably made to apply on Greg's tree.
> > 
> > Regards,
> > Mauro
> > 
> 
> Yes, I submit patches to Greg's tree. Should I clone your
> tree?

I'll take this one as it builds on a change in my tree.

thanks,

greg k-h
