Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106Ab3CHBcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 20:32:20 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:51106 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366Ab3CHBcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 20:32:19 -0500
Date: Fri, 8 Mar 2013 01:32:18 +0000
From: Eric Wong <normalperson@yhbt.net>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] epoll: add tracepoints for epitem enqueue/dequeue
Message-ID: <20130308013218.GB31830@dcvr.yhbt.net>
References: <20130304030500.GA29365@dcvr.yhbt.net>
 <1362366368-15246-1-git-send-email-normalperson@yhbt.net>
 <1362366368-15246-2-git-send-email-normalperson@yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362366368-15246-2-git-send-email-normalperson@yhbt.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Putting this on hold for now.

I'm awaiting answers for <20130307112639.GA25130@dcvr.yhbt.net>,
(Subject: epoll: possible bug from wakeup_source activation)
this patch may hide the possible bug I'm referring to in that email.
