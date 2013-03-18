Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab3CRKh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:37:29 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:56846 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab3CRKh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:37:27 -0400
Date: Mon, 18 Mar 2013 10:37:26 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Linux kernel Wait-Free Concurrent Queue
 Implementation
Message-ID: <20130318103726.GA8630@dcvr.yhbt.net>
References: <20130311213602.GB9829@Krystal>
 <20130314042227.GA15675@dcvr.yhbt.net>
 <20130314131855.GA9155@Krystal>
 <20130314190746.GA16120@dcvr.yhbt.net>
 <20130316220216.GA25099@dcvr.yhbt.net>
 <20130317020353.GA9344@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130317020353.GA9344@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> Thanks for providing this detailed scenario. I think there is an
> important aspect in the use of splice I suggested on which we are not
> fully understanding each other. I will annotate your scenario below with
> clarifications:

Ah yes, I somehow thought splice would overwrite its destination.
I've confirmed everything works as expected and have an updated
RFC coming.
