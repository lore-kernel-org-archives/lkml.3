Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab3K0Sng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 13:43:36 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:49293 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3K0Snc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 13:43:32 -0500
Message-ID: <1385577820.4307.144.camel@haakon3.risingtidesystems.com>
Subject: Re: Re: scsi-mq + open-iscsi support patches..?
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: kedacomkernel <kedacomkernel@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>
Date: Wed, 27 Nov 2013 10:43:40 -0800
In-Reply-To: <201311271046199969490@gmail.com>
References: <1382997816.19256.767.camel@haakon3.risingtidesystems.com>
	 <5273BEBF.2090008@cs.wisc.edu>
	 <1383338230.4216.9.camel@haakon3.risingtidesystems.com>
	 <37724B2049F71D4C9B086F99DDB2DE1126E31C7C@CMEXMB1.ad.emulex.com>
	 ,  <1383591411.4216.25.camel@haakon3.risingtidesystems.com>
	 <201311271046199969490@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jianpeng,

(Trimming CC's)

On Wed, 2013-11-27 at 10:46 +0800, kedacomkernel wrote:
> Hi all，
> 	I used target-pending/scsi-mq to test intel ahci，but it can't work.I
> modify some places, now it can work.But still met hung task or oops.

So after looking at your patches sent offlist, I don't exactly
understand why they are necessary for AHCI to function.

> Who can receive my patch for that?

Please repost your patches to linux-scsi, with the specifics of each bug
you've encountered, and why each patch is necessary to address the
issue.

Thanks!

--nab


