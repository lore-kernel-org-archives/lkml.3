Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaCHAsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 19:48:08 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45134 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaCHAsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 19:48:06 -0500
Date: Fri, 07 Mar 2014 19:48:01 -0500 (EST)
Message-Id: <20140307.194801.1893514114998807038.davem@davemloft.net>
To: eparis@redhat.com
Cc: ebiederm@xmission.com, sgrubb@redhat.com, rgb@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH] audit: Simplify by assuming the callers socket
 buffer is large enough
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394232722.17779.57.camel@flatline.rdu.redhat.com>
References: <7457128.6VP2v68V93@x2>
	<87wqg8zfj4.fsf@xmission.com>
	<1394232722.17779.57.camel@flatline.rdu.redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Mar 2014 16:48:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>
Date: Fri, 07 Mar 2014 17:52:02 -0500

> Audit is non-tolerant to failure and loss.

Netlink is not a loss-less transport.
