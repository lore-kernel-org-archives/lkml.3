Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbaJ3LMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:12:42 -0400
Received: from mail.gnuher.de ([78.47.12.54]:42053 "EHLO mail.gnuher.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758162AbaJ3LMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:12:40 -0400
X-Greylist: delayed 1179 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2014 07:12:40 EDT
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: Sven Geggus <lists@fuchsschwanzdomain.de>
Subject: overlayfs (3.18-rc2): NFS completely unsupported?
Date: Thu, 30 Oct 2014 10:52:57 +0000 (UTC)
Organization: Geggus clan, virtual section
Message-ID: <m2t5a9$7fd$1@home.geggus.net>
NNTP-Posting-Host: home.geggus.net
X-Trace: home.geggus.net 1414666377 7661 192.168.3.1 (30 Oct 2014 10:52:57 GMT)
X-Complaints-To: usenet@geggus.net
NNTP-Posting-Date: Thu, 30 Oct 2014 10:52:57 +0000 (UTC)
User-Agent: tin/2.1.1-20120623 ("Mulindry") (UNIX) (Linux/3.16.1 (x86_64))
Cancel-Lock: sha1:W9XZDftHrnL7em1BiXrY7KC8F+U=
X-TERMINAL: rxvt-unicode-256color
X-OS: Debian GNU/Linux (Kernel 3.16.1)
X-remote-host: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm testing overlayfs in kernel 3.18-rc2 because I hoped to be able to
replace aufs and would be able to return to mainline kernels in future.

overlayfs documentation states, that NFS is unsupported in "upper
filesystem", but I do not manage to make it work with a ro NFS lowerdir as
well. All I get is:

overlayfs: filesystem of lowerdir is not supported

This is what I try:
mount -t overlayfs -olowerdir=/etc,upperdir=/local/etc,workdir=/local/ovldir overlayfs /mnt

/local is tmpfs in this case.

If this is _not_ supposed to work I would strongly suggest, to clarify NFS
support in Documentation/filesystems/overlayfs.txt

Regards

Sven

-- 
"Das ist halt der Unterschied: Unix ist ein Betriebssystem mit Tradition,
 die anderen sind einfach von sich aus unlogisch."
                          (Anselm Lingnau in de.comp.os.unix.discussion)
/me ist giggls@ircnet, http://sven.gegg.us/ im WWW
