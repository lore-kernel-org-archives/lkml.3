Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbbAVQ0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:26:51 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:33969 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbbAVQ0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:26:48 -0500
Date: Thu, 22 Jan 2015 08:26:46 -0800
From: Darren Hart <dvhart@infradead.org>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: Re: [PATCH v2 2/3] asus-laptop: use DEVICE_ATTR_* macros
Message-ID: <20150122162646.GA66191@vmdeb7>
References: <20150121182803.GC7386@vmdeb7>
 <1741852285.168343.1421871557328.JavaMail.root@mail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1741852285.168343.1421871557328.JavaMail.root@mail>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 03:19:17PM -0500, Vivien Didelot wrote:
> Hi Darren,
> 
> > > Use DEVICE_ATTR_{RO,WO,RW} macros to simplify attributes
> > > declarations.
> >
> > It does a lot more than that, including a lot of seemingly
> > superfluous reformatting of function declarations and renaming.
> 
> What do you mean? DEVICE_ATTR_RW(foo) requires foo_show() and foo_store()
> functions, not show_foo() and store_foo().

Ah yes, of course. Perhaps obvious in hindsight, but a bit more explanation in
the commit message would have eliminated the confusion.

Always provide enough information in your commit log to explain to someone else
that hasn't been looking at the code as recently as you have to understand the
problem, the solution, and which provides sufficient explanation for all changes
included in the patch.

Please resubmit with a more complete commit message.

-- 
Darren Hart
Intel Open Source Technology Center
