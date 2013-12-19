Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3LSJM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:12:27 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:60319 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab3LSJKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:10:55 -0500
Subject: Re: [RFC 1/2] CRC32 Add GenWQE CRC to kernel CRC code
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de
In-Reply-To: <20131219005557.GB32112@kroah.com>
References: <1386592244-2521-7-git-send-email-haver@linux.vnet.ibm.com>
	 <1386780563-1722-1-git-send-email-haver@linux.vnet.ibm.com>
	 <20131219005557.GB32112@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Thu, 19 Dec 2013 10:10:42 +0100
Message-ID: <1387444242.10173.3.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121909-3548-0000-0000-0000078934D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Am Mittwoch, den 18.12.2013, 16:55 -0800 schrieb Greg KH:
> > ---
> >  include/linux/crc32.h |    2         2 +     0 -     0 !
> >  lib/crc32.c           |   10         10 +    0 -     0 !
> >  lib/crc32defs.h       |    5         5 +     0 -     0 !
> >  lib/gen_crc32table.c  |   39         31 +    8 -     0 !
> >  4 files changed, 48 insertions(+), 8 deletions(-)
> 
> What kind of crazy diffstat is that?  What generated it? 

Those two patches I generated with quilt. I used an obviously strange
setting in my .quiltrc which was:

  QUILT_DIFFSTAT_OPTS="-f0"

Removing this it looks better now:
---
 include/linux/crc32.h |    2 ++
 lib/crc32.c           |   10 ++++++++++
 lib/crc32defs.h       |    6 ++++++
 lib/gen_crc32table.c  |   39 +++++++++++++++++++++++++++++++--------
 4 files changed, 49 insertions(+), 8 deletions(-)

The other patches I generated with git.

Regards

Frank

