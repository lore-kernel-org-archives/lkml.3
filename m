Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbaAISke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:40:34 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:47432 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408AbaAISkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:40:25 -0500
Message-ID: <1389292470.1792.109.camel@misato.fc.hp.com>
Subject: Re: kdump failed because of hotplug memory adding in kdump kernel
From: Toshi Kani <toshi.kani@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Baoquan <bhe@redhat.com>,
        linux-acpi@vger.kernel.org, zhangyanfei@cn.fujitsu.com,
        tangchen@cn.fujitsu.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, dyoung@redhat.com
Date: Thu, 09 Jan 2014 11:34:30 -0700
In-Reply-To: <20140109182310.GG25897@redhat.com>
References: <52CD6E33.400@redhat.com> <20140108155829.GC13649@redhat.com>
	 <8500545.JVNPnKcyD1@vostro.rjw.lan>
	 <1389226308.1792.39.camel@misato.fc.hp.com>
	 <20140109145035.GB25897@redhat.com>
	 <1389283439.1792.66.camel@misato.fc.hp.com>
	 <20140109162427.GF25897@redhat.com>
	 <1389288265.1792.108.camel@misato.fc.hp.com>
	 <20140109182310.GG25897@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-09 at 13:23 -0500, Vivek Goyal wrote:
> On Thu, Jan 09, 2014 at 10:24:25AM -0700, Toshi Kani wrote:
> 
> [..]
> > > I think creating a new command line option is simpler as compared to
> > > creating a new flag in bootparam which in turn disables memory hotplug.
> > > More users can use that option. For example, if for some reason hotplug
> > > code is crashing, one can just disable it on command line as work around
> > > and move on.
> > 
> > I do not have a strong opinion about having such option.  However, I
> > think it is more user friendly to keep the exactmap option works alone
> > on any platforms.
> 
> I think we should create internally a variable which will disable memory
> hotplug. And set that variable based on memmap=exactmap, mem=X and also
> provide a way to disable memory hotplug directly using command line
> option.
> 
> Current kexec-tools can use memmap=exactmap and be happy. I am writing
> a new kexec syscall and will not be using memmap=exactmap and would need
> to use that command line option to disable memory hotplug behavior.

Sounds good to me.

Thanks,
-Toshi

