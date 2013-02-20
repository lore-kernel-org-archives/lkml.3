Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934607Ab3BTC0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 21:26:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:25129 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934573Ab3BTC0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 21:26:41 -0500
X-IronPort-AV: E=Sophos;i="4.84,699,1355068800"; 
   d="scan'208";a="6732243"
Subject: Re: [PATCH v4 1/4] acpi: move x86/mm/srat.c to
 x86/kernel/acpi/srat.c
From: li guang <lig.fnst@cn.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com
In-Reply-To: <1361326913.7859.41.camel@liguang.fnst.cn.fujitsu.com>
References: <1360894992-14818-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <1360894992-14818-2-git-send-email-lig.fnst@cn.fujitsu.com>
	 <alpine.DEB.2.02.1302191320410.6322@chino.kir.corp.google.com>
	 <1361324355.7859.35.camel@liguang.fnst.cn.fujitsu.com>
	 <1361325113.7859.37.camel@liguang.fnst.cn.fujitsu.com>
	 <alpine.DEB.2.02.1302191802490.14999@chino.kir.corp.google.com>
	 <1361326913.7859.41.camel@liguang.fnst.cn.fujitsu.com>
Date: Wed, 20 Feb 2013 10:26:41 +0800
Message-ID: <1361327201.7859.44.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 10:25:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 10:25:54,
	Serialize complete at 2013/02/20 10:25:54
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-02-20三的 10:21 +0800，li guang写道：
> 在 2013-02-19二的 18:08 -0800，David Rientjes写道：
> > On Wed, 20 Feb 2013, li guang wrote:
> > 
> > > > > This doesn't apply to Linus' tree nor does it apply to linux-next.  Which 
> > > > > tree are you basing this on?
> > > > 
> > > > I did based on linux-next, 
> > > > but it seems without commit 479a99a8e510c8839e0d3d3de8391f8bc61b9760
> > > > which you may want to see.
> > > > let me see why it missed.
> > > 
> > > I pulled latest for linux-next
> > > and can apply my patches smoothly.
> > > 
> > 
> > No, it doesn't.  From next-20130219, you're missing at least two patches:
> > 
> > 3795e4893203 ("acpi, memory-hotplug: extend movablemem_map ranges to the end of node")
> > 9a561f4dfd70 ("acpi, memory-hotplug: support getting hotplug info from SRAT")
> > 
> > I'm trying to be patient in reviewing your patches, but please double 
> > check your work.
> 
> I have to say my latest pull has these commit, and can apply
> successfully.
> really don't know why you can't apply.
> 

I mean although my patches did not based on latest linux-next(miss
several commits), but as I can see, they can be applied to latest
linux-next (tag next-20130218) successfully.



