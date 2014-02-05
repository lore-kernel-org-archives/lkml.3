Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaBEU4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:56:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:29446 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754605AbaBEU4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:56:01 -0500
Date: Wed, 5 Feb 2014 15:55:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, rientjes@google.com,
        akpm@linux-foundation.org, penberg@kernel.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH v3] slub: fix false-positive lockdep warning in
 free_partial()
Message-ID: <20140205155559.0884f959@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.10.1402051439100.23701@nuc>
References: <52F1F25F.20402@parallels.com>
	<1391588133-15469-1-git-send-email-vdavydov@parallels.com>
	<20140205195837.GA6857@home.goodmis.org>
	<alpine.DEB.2.10.1402051439100.23701@nuc>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014 14:42:26 -0600 (CST)
Christoph Lameter <cl@linux.com> wrote:


> > That, IMNSHO, is a much better solution
> 
> Ok with me. It just adds another variant of remove_partial.

That's a common practice in the kernel though.

-- Steve
