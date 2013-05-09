Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab3EIIqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:46:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab3EIIqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:46:00 -0400
Date: Thu, 9 May 2013 10:45:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: HID: protect hid_debug_list
In-Reply-To: <alpine.DEB.2.02.1305081431300.7947@parag-iMac>
Message-ID: <alpine.LNX.2.00.1305091045030.23038@pobox.suse.cz>
References: <alpine.DEB.2.02.1305081431300.7947@parag-iMac>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 May 2013, Parag Warudkar wrote:

> Hi Jiri
> 
> Commit 2353f2bea307390e015493118e425152b8a5a431 HID: protect 
> hid_debug_list causes the below BUG due to mutex_lock being called in 
> atomic context - does this need to be converted to a spin lock?

Hi Parag,

I already have fix for that queued [1] and will be pushing it to Linus 
shortly.

[1] https://git.kernel.org/cgit/linux/kernel/git/jikos/hid.git/commit/?h=for-3.10/upstream-fixes&id=1deb9d341d475ff84262e927d6c0e36fecb9942e

-- 
Jiri Kosina
SUSE Labs
