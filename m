Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaIHMNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:13:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbaIHMNt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:13:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1410168160-3624-1-git-send-email-lftan@altera.com>
References: <1410168160-3624-1-git-send-email-lftan@altera.com>
To: Ley Foon Tan <lftan@altera.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        lftan.linux@gmail.com, cltang@codesourcery.com
Subject: Re: [PATCH v3 00/29] nios2 Linux kernel port
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18038.1410178417.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Mon, 08 Sep 2014 13:13:37 +0100
Message-ID: <18039.1410178417@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ley Foon Tan <lftan@altera.com> wrote:

> Nios2 GCC port is in mainline and will be in the FSF 4.9 release.
> 
> The patchset are based on v3.17-rc3 and can also be found in the following git tree:
> git://git.rocketboards.org/linux-socfpga-next.git  nios2-upstream

Fedora carries a nios2 cross-compiler from F19 onwards:

warthog>yum list \*nios2\*
Loaded plugins: auto-update-debuginfo
Installed Packages
binutils-nios2-linux-gnu.x86_64          2.24-5.fc20            @updates-testing
gcc-c++-nios2-linux-gnu.x86_64           4.9.1-1.fc20           @updates-testing
gcc-nios2-linux-gnu.x86_64               4.9.1-1.fc20           @updates-testing

David
