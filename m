Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760755AbaJ3SRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 14:17:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42819 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758594AbaJ3SRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 14:17:04 -0400
Date: Thu, 30 Oct 2014 18:17:01 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: stable@vger.kernel.org
Cc: kernel-team@lists.ubuntu.com, debian-kernel@lists.debian.org,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        lwn@lwn.net
Subject: [ANNOUNCE] Linux 3.16.y.z extended stable support
Message-ID: <20141030181701.GD9032@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Ubuntu kernel team is pleased to announce that we will be
providing extended stable support for the Linux 3.16 kernel until
April 2016 as a third party effort maintained on our infrastructure.
The team will pick up stable maintenance where Greg KH left off with
v3.16.7 [1].  Thank you, Greg.

In addition to the Ubuntu 14.10 "Utopic Unicorn" release, the Debian 8
"Jessie" release will also be based on this kernel [2].  Since the
regular support for "Jessie" will go beyond April 2016, after this
date Ben Hutchings (or myself) will continue the Linux 3.16 kernel
maintenance.

Our linux-3.16.y{-queue,-review} stable branches will fork from
v3.16.7
and will be published here:

    git://kernel.ubuntu.com/ubuntu/linux.git

We will use the same stable request/review workflow and follow the
standard upstream stable kernel rules.  More details are available
here [3].

We welcome any feedback and contribution to this effort.  We will be
posting the first review cycle patch set in a week or two.

[1] https://lkml.org/lkml/2014/10/30/583
[2] https://lists.debian.org/debian-kernel/2014/07/msg00413.html
[3] http://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Cheers,
-- 
Luís Henriques
Ubuntu Kernel Team, Canonical Ltd.
