Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3JIUUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 16:20:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745Ab3JIUUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 16:20:45 -0400
Date: Wed, 9 Oct 2013 16:20:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, ebiederm@xmission.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, jingbai.ma@hp.com
Subject: Re: [PATCH 0/2] x86, apic: Disable BSP if boot cpu is AP
Message-ID: <20131009202012.GO6383@redhat.com>
References: <20130829092458.5476.10277.stgit@localhost6.localdomain6>
 <521F5297.4070906@linux.intel.com>
 <521FDE8D.4040807@jp.fujitsu.com>
 <5220BDBC.2060807@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5220BDBC.2060807@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 08:43:56AM -0700, H. Peter Anvin wrote:
> On 08/29/2013 04:51 PM, HATAYAMA Daisuke wrote:
> > 
> > This is not a regression just as Eric explains.
> > 
> > There is also my explanation in the description of the 2nd patch. I
> > should have described so here explicitly.
> > 
> 
> OK.  We're probably days away from a merge window, so I would like to
> put this in the queue for 3.13.

Hi hpa,

Have you queued up these patches for 3.13?

Thanks
Vivek
