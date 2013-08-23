Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab3HWTu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:50:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196Ab3HWTu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:50:26 -0400
Date: Fri, 23 Aug 2013 21:50:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@deuxcents.site
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        mhocko@suse.cz, hare@suse.de, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/4 v6] Avoid softlockups in console_unlock()
In-Reply-To: <20130822151427.38650aae09e909d52a57b393@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1308232149190.25124@deuxcents.site>
References: <1377072512-7986-1-git-send-email-jack@suse.cz> <20130821142723.5fd8c0b0062b35ee83a68dcc@linux-foundation.org> <20130821225915.GA16653@quack.suse.cz> <20130822124913.c6de8fe61e9fd601bd83ff63@linux-foundation.org> <20130822215742.GA32040@quack.suse.cz>
 <20130822151427.38650aae09e909d52a57b393@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013, Andrew Morton wrote:

> Years of hard experience have taught me: don't muck with printk.  It
> needs to be robust, simple and to have minimum dependency on both the
> calling environment and on correctly functioning kernel components. 
> printk and NMI are the harshest environments we have to deal with.

NMI is harsh due to its design.

printk() is harsh because of the way we have implemented it. So we'd 
better work on fixing it, methinks.

-- 
Jiri Kosina
SUSE Labs
