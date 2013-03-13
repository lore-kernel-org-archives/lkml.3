Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab3CMLTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:19:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:3344 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab3CMLTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:19:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,836,1355126400"; 
   d="scan'208";a="300881758"
Message-ID: <1363173638.11441.24.camel@sauron.fi.intel.com>
Subject: Re: MTD : Kernel oops when remounting ubifs as read/write
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Mark Jackson <mpfj-list@mimc.co.uk>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, adrian.hunter@intel.com
Date: Wed, 13 Mar 2013 13:20:38 +0200
In-Reply-To: <51405F3A.3090901@mimc.co.uk>
References: <5134CEF9.5070502@mimc.co.uk>
	 <1363087506.3348.62.camel@sauron.fi.intel.com>
	 <51405F3A.3090901@mimc.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-13 at 11:12 +0000, Mark Jackson wrote:
> > -	if (c->space_fixup) {
> > -		err = ubifs_fixup_free_space(c);
> > -		if (err)
> > -			goto out;
> > -	}
> > -
> >  	mutex_unlock(&c->umount_mutex);
> >  	return err;
> > 
> 
> Sorry ... this just locks up the unit.

Am I right that to reproduce it I need any image with the 'fixup' flag
set, then I should put it on the flash, mount it R/O and then remount
R/W. Right?

-- 
Best Regards,
Artem Bityutskiy

