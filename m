Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab3HTTjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 15:39:39 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42681 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab3HTTji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 15:39:38 -0400
Date: Tue, 20 Aug 2013 15:39:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joe Jin <joe.jin@oracle.com>
Cc: Vaughan Cao <vaughan.cao@oracle.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mingo@redhat.com,
        hpa@zytor.com, tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] xen: initialize xen panic handler for PVHVM
Message-ID: <20130820193915.GJ12037@phenom.dumpdata.com>
References: <1376640656-32381-1-git-send-email-vaughan.cao@oracle.com>
 <20130816124327.GC10190@konrad-lan.dumpdata.com>
 <5211B8C2.1010702@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5211B8C2.1010702@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 02:18:42PM +0800, Joe Jin wrote:
> On 08/16/13 20:43, Konrad Rzeszutek Wilk wrote:
> > Could you tell me what has been happening without this patch?
> 
> Without this patch, Xen would not get pvhvm crash event, any config for
> on_crash in guest configure file will not be triggered.

applied for 3.12
> 
> Thanks,
> Joe
> 
