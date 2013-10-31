Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab3JaQEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:04:30 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:59636 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3JaQE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:04:28 -0400
From: Paul Moore <paul@paul-moore.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        libseccomp-discuss@lists.sourceforge.net
Subject: ANN: libseccomp 2.1.1 released
Date: Thu, 31 Oct 2013 12:04:25 -0400
Message-ID: <5205940.GnC9iqXGhX@sifl>
User-Agent: KMail/4.11.2 (Linux/3.10.13-gentoo; KDE/4.11.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to announce a maintenance release for the libseccomp library, 
libseccomp version 2.1.1.  The libseccomp library provides an easy to use, 
platform independent, interface to the Linux enhanced syscall filtering 
mechanism that was first introduced in Linux 3.5.

 * http://sourceforge.net/projects/libseccomp

This new version of libseccomp is binary compatible with versions 2.0.0 and 
greater while retaining source compatibility with versions 1.0.0 and greater.  
All users are encouraged to upgrade to the new version at their earliest 
convenience.

Changes in the 2.1.1 release include:

 * Fixes to the internal syscall rule filtering database
 * Improvements to the build and automated test systems
 * Coding style verification tools

Finally, thank you to everyone who has submitted suggestions, provided testing 
help, and contributed patches to the project.

-- 
paul moore
www.paul-moore.com

