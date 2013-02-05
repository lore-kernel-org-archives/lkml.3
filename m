Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab3BEF5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 00:57:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:32366 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab3BEF5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 00:57:46 -0500
X-IronPort-AV: E=Sophos;i="4.84,603,1355068800"; 
   d="scan'208";a="6690307"
Subject: Re: [PATCH] mm: break circular include from linux/mmzone.h
From: li guang <lig.fnst@cn.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
In-Reply-To: <alpine.DEB.2.02.1302042119370.31498@chino.kir.corp.google.com>
References: <1360037707-13935-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <alpine.DEB.2.02.1302042119370.31498@chino.kir.corp.google.com>
Date: Tue, 05 Feb 2013 13:56:36 +0800
Message-ID: <1360043796.4449.24.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 13:55:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 13:56:28,
	Serialize complete at 2013/02/05 13:56:28
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-02-04一的 21:20 -0800，David Rientjes写道：
> On Tue, 5 Feb 2013, liguang wrote:
> 
> > linux/mmzone.h included linux/memory_hotplug.h,
> > and linux/memory_hotplug.h also included
> > linux/mmzone.h, so there's a bad cirlular.
> > 
> 
> And both of these are protected by _LINUX_MMZONE_H and 
> __LINUX_MEMORY_HOTPLUG_H, respectively, so what's the problem?

obviously, It's a logical error,
and It has no more effect other than
combination of these 2 header files.
so, why don't we separate them?





