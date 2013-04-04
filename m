Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763453Ab3DDF3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 01:29:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763437Ab3DDF3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 01:29:07 -0400
Date: Thu, 4 Apr 2013 10:58:54 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Petr Matousek <pmatouse@redhat.com>
Subject: Re: [PATCH] To add NULL pointer check
In-Reply-To: <1365034495.4353.14.camel@kjgkr>
Message-ID: <alpine.LFD.2.03.1304041053140.6549@erqung.pbz>
References: <alpine.LFD.2.03.1304021808410.12716@erqung.pbz> <1364958193.4353.4.camel@kjgkr> <alpine.LFD.2.03.1304031224180.21402@erqung.pbz> <1364975688.4353.7.camel@kjgkr> <alpine.LFD.2.03.1304031342550.23577@erqung.pbz> <1365034495.4353.14.camel@kjgkr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+-- On Thu, 4 Apr 2013, Jaegeuk Kim wrote --+
| Why should we take unnecessary locks and an f2fs_submit_bio call?

  Yep, we should not. I wasn't sure if these are unnecessary when 
a_ops->writepage = NULL.

Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
