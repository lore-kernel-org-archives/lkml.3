Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab3CUMBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 08:01:37 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:53006 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab3CUMBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:01:36 -0400
Date: Thu, 21 Mar 2013 12:01:36 +0000
From: Eric Wong <normalperson@yhbt.net>
To: linux-kernel@vger.kernel.org
Cc: Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC v3 1/2] epoll: avoid spinlock contention with wfcqueue
Message-ID: <20130321120136.GA10516@dcvr.yhbt.net>
References: <20130321115259.GA17883@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321115259.GA17883@dcvr.yhbt.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Wong <normalperson@yhbt.net> wrote:
> This is still not a proper commit, I've lightly tested this.

Btw, full series here (already sent to LKML and some in -mm)
http://yhbt.net/epoll-wfcqueue-v3.8.3-20130321.mbox
(should apply cleanly to all 3.8/3.9 kernels)
