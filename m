Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab3JFIJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 04:09:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab3JFIJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 04:09:31 -0400
Date: Sun, 6 Oct 2013 13:39:16 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Fix NULL pointer dereference while loading
 initramfs
In-Reply-To: <20131005142824.d8e49226.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.03.1310061338270.4205@erqung.pbz>
References: <alpine.LFD.2.03.1309151431180.7830@erqung.pbz> <20130923124110.9b8aebd78c2b602255f1dc1f@linux-foundation.org> <alpine.LFD.2.03.1310060211420.2830@erqung.pbz> <20131005142824.d8e49226.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

+-- On Sat, 5 Oct 2013, Andrew Morton wrote --+
| On Sun, 6 Oct 2013 02:12:15 +0530 (IST) P J P <ppandit@redhat.com> wrote:
| Not yet, but it's in the queue.

  I see; Thank you for an update. I appreciate it.

Please let me know if there are changes to be done. Or if you think I could 
send similar patches for other architectures too. I thought once these are 
reviewed for one architecture, replicating the same changes for others would be 
safe & easy.


Thank you so much!
--
Prasad J Pandit / Red Hat Security Response Team
