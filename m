Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab3CYSJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 14:09:47 -0400
Received: from a192-166.smtp-out.amazonses.com ([199.255.192.166]:30443 "EHLO
	a192-166.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932459Ab3CYSJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 14:09:45 -0400
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Mar 2013 14:09:45 EDT
Date: Mon, 25 Mar 2013 18:00:16 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: CAI Qian <caiqian@redhat.com>
cc: David Rientjes <rientjes@google.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: BUG at kmem_cache_alloc
In-Reply-To: <364499626.5604667.1364189870552.JavaMail.root@redhat.com>
Message-ID: <0000013da2b53120-1c207286-3e36-483e-9fd9-90fc529d48aa-000000@email.amazonses.com>
References: <364499626.5604667.1364189870552.JavaMail.root@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.192.166
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please enable CONFIG_SLUB_DEBUG_ON or run the kernel with slub_debug on
the command line to get detailed diagnostics as to what causes this.
