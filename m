Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935648Ab3FTDLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:11:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65282 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935534Ab3FTDLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:11:06 -0400
Message-ID: <1371697844.5739.29.camel@marge.simpson.net>
Subject: Re: [PATCH v2] Make transparent hugepages cpuset aware
From: Mike Galbraith <bitbucket@online.de>
To: David Rientjes <rientjes@google.com>
Cc: Robin Holt <holt@sgi.com>, Alex Thorlton <athorlton@sgi.com>,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        linux-doc@vger.kernel.org, linux-mm@kvack.org
Date: Thu, 20 Jun 2013 05:10:44 +0200
In-Reply-To: <alpine.DEB.2.02.1306191939250.24151@chino.kir.corp.google.com>
References: <1370967244-5610-1-git-send-email-athorlton@sgi.com>
	 <alpine.DEB.2.02.1306111517200.6141@chino.kir.corp.google.com>
	 <20130618164537.GJ16067@sgi.com>
	 <alpine.DEB.2.02.1306181654350.4503@chino.kir.corp.google.com>
	 <20130619093212.GX3658@sgi.com>
	 <alpine.DEB.2.02.1306191419081.13015@chino.kir.corp.google.com>
	 <20130620022739.GF3658@sgi.com>
	 <alpine.DEB.2.02.1306191939250.24151@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:/ZyEOnNbt+t9W2HKLzHBPc5p3eZjNwD0fdpTcMONM8J
 mB4vQ3x8bqBkNjnx1Wslrf4hsc+BJbtoNpwEqT5VNZIR9UikMA
 Y3Bn0rQESKgLeVGaVqU1L2JNGQHTAzMZHh7eTrKyH8gX4kbvUc
 qJ8XMBBWjii2x6eQjFe0j/Hk2bTZIfcWhSgrs+Lh/yur82fG75
 Jb4BVrUpeVRscUCWIFOd81hNDXEogoK0cle6bz3lM2cbiAGoCk
 zmD/fZ1BIE34GikqEbReadjHZHaPj/I9LB1lQGmwd0w0wCjY+c
 PyWLjQB3wRyNwOtsQ4dQBh9VesXUYjbfdmQwNHgudVnSMpAeEz
 BuYi5Qr3W45JdQtFUsJ6SQb7SWAMk8hgnjEs7mzt8wvDxTaSgJ
 xFXHIVyMly0iQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-19 at 19:43 -0700, David Rientjes wrote: 
>   
> I'm suspecting that you're referring to enlarged rss because of 
> khugepaged's max_ptes_none and because you're abusing the purpose of 
> cpusets for containerization.

Why is containerization an abuse?  What's wrong with renting out chunks
of a big box farm on the fly like a task motel?  If a realtime customer
checks in, he's not gonna be thrilled about sharing a room.

-Mike

