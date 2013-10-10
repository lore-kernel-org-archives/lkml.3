Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab3JJHHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:07:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab3JJHHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:07:12 -0400
Date: Thu, 10 Oct 2013 12:35:08 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Export initial ramdisk compression config
In-Reply-To: <20131009144849.96389b7cdb3a553e52682137@linux-foundation.org>
Message-ID: <alpine.LFD.2.03.1310101228410.29725@erqung.pbz>
References: <alpine.LFD.2.03.1309151434580.7830@erqung.pbz> <20130923125256.e53b51a137a19a972c6026a2@linux-foundation.org> <alpine.LFD.2.03.1309250035480.5312@erqung.pbz> <20131009144849.96389b7cdb3a553e52682137@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Andrew,

+-- On Wed, 9 Oct 2013, Andrew Morton wrote --+
| It would be better to make the change in one place, rather than for each 
| architecture.  That would appear to involve moving a hunk from 
| arch/x86/Makefile into init/Makefile, or perhaps ./Makefile.
 
  Right, I was trying to figure the same. I'll do the changes and send an 
updated patch.

Thank you so much for reviewing it and the update.

Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
