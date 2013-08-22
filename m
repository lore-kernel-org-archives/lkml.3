Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab3HVKoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 06:44:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab3HVKoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 06:44:14 -0400
Date: Thu, 22 Aug 2013 12:44:11 +0200
From: Anton Arapov <anton@redhat.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ATTEND] oops.kernel.org prospect
Message-ID: <20130822104411.GA11714@bandura.laptop>
References: <20130819085405.GA22328@bandura.laptop>
 <20130819145505.GB15178@kroah.com>
 <20130819151643.GC19070@bandura.laptop>
 <20130819153939.GA23875@thunk.org>
 <20130819155202.GF19070@bandura.laptop>
 <20130821194357.GA22587@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130821194357.GA22587@electric-eye.fr.zoreil.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 09:43:57PM +0200, Francois Romieu wrote:
> Anton Arapov <anton@redhat.com> :
> [...]
> > Oh well,... I didn't have a time for this right now, nor project is
> > not exactly in the state I'm willing to show (mostly webui) 
> 
> I have sorted the r8169 oopses by kernel revision to start with the most
> recent kernels. I don't get why the r8169 driver appears in the
> "Caused by:" field when
> - the bug is about "scheduling while atomic: Xorg/3042/0×00000001"
> - the kernel is PDWO with fglrx
> - r8169 appears in the module list, nowhere else (not even the oops)
> 
> I tried :
> http://oops.kernel.org/browse-reports/?c=1&d=1&oopsclass=default&oopstype=default&distro=default&module=&driver=r8169&function=&file=&bugline=&kernel=&tainted=true&search=submit
> 
> (0 answer if Stack, Registers or Disassembled code is added)
> ("tainted=true" while "Untainted only" was asked for, huh ?)
> 
> The answers contains:
> http://oops.kernel.org/browse-reports/oops-detail/?id=29778
> and
> http://oops.kernel.org/browse-reports/oops-detail/?id=29856
> 
> I can't even find the "r8169" word in those.
> Is it the currently expected behavior ?

Thanks for the report. I will check it.

Anton.
