Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab3A1QLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:11:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147Ab3A1QLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:11:17 -0500
From: Paul Moore <pmoore@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        libseccomp-discuss@lists.sourceforge.net
Subject: ANN: libseccomp 2.0.0 released
Date: Mon, 28 Jan 2013 11:11:04 -0500
Message-ID: <1761584.CAfxVeTaQM@sifl>
Organization: Red Hat
User-Agent: KMail/4.9.5 (Linux/3.7.3-gentoo; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to announce a new major release for the libseccomp library, 
libseccomp version 2.0.0.  The libseccomp library provides an easy to use, 
platform independent, interface to the Linux enhanced syscall filtering 
mechanism that was first introduced in Linux 3.5.

 * http://sourceforge.net/projects/libseccomp
 * http://sf.net/projects/libseccomp/files/libseccomp-2.0.0.tar.gz/download

This new version of libseccomp is source compatible with version 1.0.0 and 
later of the library.  Both the libseccomp v2.x and libseccomp v1.x libraries 
should be able to coexist on the same system but all users are encouraged to 
upgrade to the new version at their earliest convenience.

Changes in the 2.0.0 release include:

 * Fixes for the x86 multiplexed syscalls
 * Additions to the API to better support non-native architectures
 * Additions to the API to support multiple architectures in one filter
 * Additions to the API to resolve syscall name/number mappings
 * Assorted minor bug fixes
 * Improved build messages regardless of build verbosity
 * More automated tests added as well as a number of improvements to the test
   harness

Finally, thank you to everyone who has submitted suggestions, provided testing 
help, and contributed patches to the project.

-- 
paul moore
security and virtualization @ redhat

