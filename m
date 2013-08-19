Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab3HSLhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:37:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab3HSLht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:37:49 -0400
Date: Mon, 19 Aug 2013 13:38:07 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [3.10 regression] mei endless recursion
Message-ID: <20130819113806.GA11577@redhat.com>
References: <20130806065442.GA3509@redhat.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE81EF8@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AE81EF8@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Aug 07, 2013 at 11:15:20AM +0000, Winkler, Tomas wrote:
> > We have a bug report when system fail to boot on 3.10 . It happens due to
> > problem in mei which do endless calls:
> > 
> > mei_reset -> mei_hbm_start_req -> mei_reset -> mei_hbm_start_req -> ...
> > 
> > It did not happen on 3.9.
> 
> This is the same as https://bugzilla.kernel.org/show_bug.cgi?id=60612
> There is few issues with the reset but this major root cause should be fixed by this patch https://lkml.org/lkml/2013/7/17/219

FYI: user reported that this patch did not fix problem for him, though
system boot now, but recursion happened when he tried to login.

Thanks
Stanislaw
