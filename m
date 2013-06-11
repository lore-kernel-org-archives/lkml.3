Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab3FKSTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:19:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938Ab3FKSTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:19:00 -0400
From: Paul Moore <pmoore@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        libseccomp-discuss@lists.sourceforge.net
Subject: ANN: libseccomp 2.1.0 released
Date: Tue, 11 Jun 2013 14:18:51 -0400
Message-ID: <1651731.uq3eGijaMq@sifl>
Organization: Red Hat
User-Agent: KMail/4.10.3 (Linux/3.9.2-gentoo; KDE/4.10.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to announce a new libseccomp release, libseccomp version 2.1.0.  
The libseccomp library provides an easy to use, platform independent, 
interface to the Linux enhanced syscall filtering mechanism that was first 
introduced in Linux 3.5.

 * http://sourceforge.net/projects/libseccomp
 * http://sf.net/projects/libseccomp/files/libseccomp-2.1.0.tar.gz/download

This new version of libseccomp builds upon the previous release and should be 
a drop-in replacement for the 2.x releases with v1.x users requiring only a 
recompile.  All users are encouraged to upgrade to the new version at their 
earliest convenience.

Changes in the 2.1.0 release include:

 * Support for the x32 and ARM architectures/ABIs; removes the need for ABI 
specific seccomp BPF code, libseccomp handles this all internally
 * Improvements to the PFC code generator and the inclusion of a syscall 
number-to-name and name-to-number resolver to aid application developers
 * The usual collection of bugfixes, both large and small

Finally, thank you to everyone who has submitted suggestions, provided testing 
help, and contributed patches to the project.

-- 
paul moore
security and virtualization @ redhat

