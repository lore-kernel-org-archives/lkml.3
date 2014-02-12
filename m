Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaBLJ3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:29:43 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:49312 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaBLJ3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:29:41 -0500
Date: Wed, 12 Feb 2014 10:29:35 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-390@vm.marist.edu,
        linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ANNOUNCE] s390 31 bit kernel support removal
Message-ID: <20140212092935.GA14964@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021209-5024-0000-0000-000008B6648C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

we plan to remove 31 bit kernel support of the s390 architecture in the
Linux kernel sources.

The reason for this is quite simple: the current 31 bit kernel was broken
for nearly a year before somebody noticed.

Keeping the 31 bit kernel support adds extra maintenance and development
effort which we do not want to spend anymore, especially since the effort
seems to be quite pointless, since nobody uses (and tests) the 31 bit
kernel.

Please note, that we will not remove the 31 bit compatibility layer which
allows to run 31 bit applications with a 64 bit kernel.  It is also
possible to run a complete 31 bit user space distribution with a 64 bit
kernel.

After the removal of the 31 bit kernel support it is not possible to run
new Linux kernels on old 31 bit only machines.  The only supported 31 bit
only machines were the G6 and Multiprise 3000 introduced in 1999.  However
after nearly 15 years it seems reasonable to remove support for these old
machines.

We want to remove s390 31 bit kernel support with Linux kernel 3.16.

Thanks,
Heiko

