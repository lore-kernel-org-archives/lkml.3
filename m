Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab3BAWBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 17:01:10 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27162 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432Ab3BAWBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 17:01:09 -0500
Date: Fri, 1 Feb 2013 14:00:58 -0800
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH] PVH linux: Use ballooning to allocate grant
 table pages
Message-ID: <20130201140058.156d3b9c@mantra.us.oracle.com>
In-Reply-To: <20130131184446.654a2289@mantra.us.oracle.com>
References: <20130131183015.13bc2bff@mantra.us.oracle.com>
	<20130131184446.654a2289@mantra.us.oracle.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013 18:44:46 -0800
Mukesh Rathor <mukesh.rathor@oracle.com> wrote:

> On Thu, 31 Jan 2013 18:30:15 -0800
> Mukesh Rathor <mukesh.rathor@oracle.com> wrote:
> 
> > This patch fixes a fixme in Linux to use alloc_xenballooned_pages()
> > to allocate pfns for grant table pages instead of kmalloc. This also
> > simplifies add to physmap on the xen side a bit.
> 
> Looking at it again, I realized rc should be signed in
> gnttab_resume(). Below again. Thanks.

Konrad, Please hold off on this patch. I discovered an issue on the 
domU side with this change. I'm currently investigating if it's 
related.

thanks,
Mukesh
