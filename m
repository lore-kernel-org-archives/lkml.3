Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614Ab3GZU2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:28:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40121 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900Ab3GZU2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:28:07 -0400
X-Sasl-enc: L3LqoEVpWdc/vzlNaRb+KP6qExzgu7FwX+lxQGlJLg+G 1374870484
Subject: Need for llistxattrat()/lgetxattrat()/lsetxattrat()
From: Colin Walters <walters@verbum.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Jul 2013 16:28:02 -0400
Message-ID: <1374870482.15230.55.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-13.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So at the moment the kernel has pretty comprehensive support for the
*at() variants of file API calls, and at one point I was rewriting my
app to be a modern Unix citizen and use the *at variants, but I ran into
one admittedly obscure corner case, which is the lack of API calls to
manipulate the extended attributes of symbolic links relative to a
dirfd.  

Correctly handling xattrs (in particular, SELinux labels) is a key part
of my application, so for now I'll just live with pathnames and their
drawbacks, but:

Is this intentional or an oversight?  If the latter, should I try a
patch?


