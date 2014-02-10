Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaBJKOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:14:22 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:52992 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaBJKOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:14:20 -0500
Date: Mon, 10 Feb 2014 02:14:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        poma <pomidorabelisima@gmail.com>
cc: Christoph Lameter <cl@linux.com>, Josh Boyer <jwboyer@redhat.com>,
        "Justin M. Forbes" <jforbes@redhat.com>, Dave Jones <davej@redhat.com>,
        kernel@lists.fedoraproject.org, linux-kernel@vger.kernel.org
Subject: Re: WARNING: CPU: 0 PID: 2243 at mm/slub.c:1007
 deactivate_slab+0x4e0/0x590()
In-Reply-To: <52F832C0.9070702@gmail.com>
Message-ID: <alpine.DEB.2.02.1402100212280.30650@chino.kir.corp.google.com>
References: <52F832C0.9070702@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014, poma wrote:

> [   83.530421] WARNING: CPU: 0 PID: 2243 at mm/slub.c:1007
> deactivate_slab+0x4e0/0x590()

Yeah, you'll need the patch from the http://marc.info/?t=139145791300002 
thread.  It's in the -mm tree as
mm-slub-list_lock-may-not-be-held-in-some-circumstances.patch and I'm 
hoping it will go into 3.14-rc3, several people have been complaining 
about it.
