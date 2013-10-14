Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3JNJDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:03:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab3JNJD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:03:29 -0400
Date: Mon, 14 Oct 2013 11:03:22 +0200
From: Petr Tesarik <ptesarik@suse.cz>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, akpm@linux-foundation.org, jingbai.ma@hp.com
Subject: Re: [PATCH 0/2] x86, apic: Disable BSP if boot cpu is AP
Message-ID: <20131014110322.32aecd6c@hananiah.suse.cz>
In-Reply-To: <20131009202012.GO6383@redhat.com>
References: <20130829092458.5476.10277.stgit@localhost6.localdomain6>
	<521F5297.4070906@linux.intel.com>
	<521FDE8D.4040807@jp.fujitsu.com>
	<5220BDBC.2060807@linux.intel.com>
	<20131009202012.GO6383@redhat.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.21; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Oct 2013 16:20:12 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Fri, Aug 30, 2013 at 08:43:56AM -0700, H. Peter Anvin wrote:
> > On 08/29/2013 04:51 PM, HATAYAMA Daisuke wrote:
> > > 
> > > This is not a regression just as Eric explains.
> > > 
> > > There is also my explanation in the description of the 2nd patch. I
> > > should have described so here explicitly.
> > > 
> > 
> > OK.  We're probably days away from a merge window, so I would like to
> > put this in the queue for 3.13.
> 
> Hi hpa,
> 
> Have you queued up these patches for 3.13?

Yeah, I'm also interested. But I think we were waiting for HATAYAMA
Daisuke to send a cleaned up version of the patch set.

@HATAYAMA: If you're too busy to clean up the series, I can do that for
you and re-send it here. But I don't want to "steal" the work from you.

Petr T
