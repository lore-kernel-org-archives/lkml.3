Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaLENXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:23:08 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:59462 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaLENXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:23:06 -0500
Date: Fri, 5 Dec 2014 13:22:50 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Alex Dubov <alex.dubov@gmail.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, corbet@lwn.net,
        richardcochran@gmail.com
Subject: Re: syscall: introduce sendfd() syscall (v.2)
Message-ID: <20141205132250.6f2f9ec1@lxorguk.ukuu.org.uk>
In-Reply-To: <1417597255-32530-1-git-send-email-oakad@yahoo.com>
References: <1417597255-32530-1-git-send-email-oakad@yahoo.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 2.a. If task A has sufficient capabilities to send signals to task B, then
> task A is already in position to do anything it wants with task B, including
> killing it outright.

Not entirely true.

- We have securirty models like SELinux
- We have namespaces and being able to send an fd between namespaces is
  not quite as flexible as you would make it

I suspect therefore it needs security hooks but otherwise looks more sane
than the current AF_UNIX approach.

