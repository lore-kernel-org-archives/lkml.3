Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965903Ab3DQGwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 02:52:35 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:52671 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965747Ab3DQGwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 02:52:34 -0400
Date: Tue, 16 Apr 2013 23:52:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, toshi.kani@hp.com,
        linuxram@us.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [Bug fix PATCH v3] Reusing a resource structure allocated by
 bootmem
In-Reply-To: <516E452A.7060703@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1304162351300.5220@chino.kir.corp.google.com>
References: <516DEC34.7040008@jp.fujitsu.com> <alpine.DEB.2.02.1304161733340.14583@chino.kir.corp.google.com> <516E2305.3060705@jp.fujitsu.com> <alpine.DEB.2.02.1304162144320.3493@chino.kir.corp.google.com> <516E452A.7060703@jp.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Apr 2013, Yasuaki Ishimatsu wrote:

> > How much memory are we talking about?
> 
> Hmm. I don't know correctly.
> 
> Here is kernel message of my system. The message is shown by mem_init().
> 

Do you have an estimate on the amount of struct resource memory that will 
be leaked if entire pages won't be freed?
