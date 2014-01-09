Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbaAIC0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 21:26:30 -0500
Received: from mail-gg0-f179.google.com ([209.85.161.179]:33904 "EHLO
	mail-gg0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaAIC02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 21:26:28 -0500
Date: Wed, 8 Jan 2014 18:26:24 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Han Pingtian <hanpt@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC] mm: prevent set a value less than 0 to min_free_kbytes
In-Reply-To: <20140108084242.GA10485@localhost.localdomain>
Message-ID: <alpine.DEB.2.02.1401081825470.15616@chino.kir.corp.google.com>
References: <20140108084242.GA10485@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jan 2014, Han Pingtian wrote:

> If echo -1 > /proc/vm/sys/min_free_kbytes, the system will hang.
> Changing proc_dointvec() to proc_dointvec_minmax() in the
> min_free_kbytes_sysctl_handler() can prevent this to happen.
> 
> Signed-off-by: Han Pingtian <hanpt@linux.vnet.ibm.com>

Acked-by: David Rientjes <rientjes@google.com>

Nice catch!
