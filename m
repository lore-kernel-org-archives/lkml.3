Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbaFUUPH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 16:15:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbaFUUPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 16:15:05 -0400
Date: Sat, 21 Jun 2014 13:14:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nick Krause <xerofoify@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        pebolle@tiscali.nl, Himangi Saraogi <himangi774@gmail.com>,
        Konrad Zapalowicz <bergo.torino@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:rtl8821ae: rewrite legacy wifi check in
 halbcoutsrc
Message-ID: <20140621201452.GA20432@kroah.com>
References: <1403283410-7022-1-git-send-email-xerofoify@gmail.com>
 <20140620195926.GY5500@mwanda>
 <1403294880.4076.7.camel@joe-AO725>
 <CAPDOMVi2humH7sL8DDkY=WJ3gWnehdeX8QEnNf6d8oTWftHXKA@mail.gmail.com>
 <1403318075.4076.31.camel@joe-AO725>
 <CAPDOMVgyttC0AY8CUbWESSBKpkskJYjC3L1AcPw_s0q=QJjLoQ@mail.gmail.com>
 <53A5834F.8050805@lwfinger.net>
 <CAPDOMVgvnNkVc9TN4MHm7UaD+nfac8C6A0kMo=q9Q237nTWUKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMVgvnNkVc9TN4MHm7UaD+nfac8C6A0kMo=q9Q237nTWUKQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 12:46:33PM -0400, Nick Krause wrote:
> Hope you enjoyed your trips , Larry.
> It would be great if you researched
> this issue in order for me to send in
> a correct patch to fix this bug.

That is not how kernel development is done, you need to do the work, not
ask others to do it for you.

best of luck,

greg k-h
