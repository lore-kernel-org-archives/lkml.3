Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaCCTo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:44:29 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:36278 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbaCCTo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:44:28 -0500
Date: Mon, 3 Mar 2014 11:44:23 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: Question on vhost_has_feature()
Message-ID: <20140303194422.GA17107@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030319-7164-0000-0000-000006919A25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michael,

Just curious about the purpose of the rcu_dereference_index_check() in
vhost_has_feature().  I don't see how it fits in.  The closest thing
I see if the use in handle_rx(), where it selects vq->log or NULL.  But
in that case, I would expect the usual RCU usage pattern to wrap an
rcu_dereference() around the vq->log.

Enlightenment?

							Thanx, Paul

