Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730Ab3CMPY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 11:24:28 -0400
Received: from mail.lurndal.org ([72.25.90.143]:52333 "EHLO mail.lurndal.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab3CMPY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 11:24:27 -0400
X-Greylist: delayed 1880 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Mar 2013 11:24:27 EDT
Date: Wed, 13 Mar 2013 07:53:02 -0700
From: Scott Lurndal <scott@lurndal.org>
To: travis@sgi.com
Cc: jason.wessel@windriver.com, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com
Subject: Re: [PATCH 05/14] KDB: add more exports for supporting KDB modules
Message-ID: <20130313145302.GA23308@mail.lurndal.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Looking back at the KDB sources originally posted on oss.sgi.com I
> did not see any restrictions on the use of KDB.  How/why was that
> restriction granted and by whom?  Was SGI, the original copyright
> owner of KDB, asked or even informed of that decision?  I'm not
> trying to be a lawyer here, but someone decided (perhaps wrongly)
> that KDB should only be used by GPL modules.

At the time that I wrote that original KDB code at SGI, there was no
intent to make it only usable by GPL modules.  If anything, it was intended
to be more in the BSD-style (anyone can use it any way they like with
attribution) than the GPLv3-style (use it our way, or else).

But then, EXPORT_SYMBOL_GPL didn't exist then.  And I think its existence
is silliness on the part of several hard-core developers.

scott lurndal
