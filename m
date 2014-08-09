Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaHII7b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 04:59:31 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:63209 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaHII71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 04:59:27 -0400
Date: Sat, 9 Aug 2014 01:59:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Aleksei Besogonov <alex.besogonov@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vm_is_stack: use for_each_thread() rather then buggy
 while_each_thread()
In-Reply-To: <20140807194721.GA5741@redhat.com>
Message-ID: <alpine.DEB.2.02.1408090159070.11855@chino.kir.corp.google.com>
References: <20140807194721.GA5741@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2014, Oleg Nesterov wrote:

> Aleksei hit the soft lockup during reading /proc/PID/smaps.
> David investigated the problem and suggested the right fix.
> 
> while_each_thread() is racy and should die, this patch updates
> vm_is_stack().
> 
> Reported-and-tested-by: Aleksei Besogonov <alex.besogonov@gmail.com>
> Suggested-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: David Rientjes <rientjes@google.com>

> Cc: stable@vger.kernel.org

3.4+
