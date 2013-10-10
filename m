Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab3JJN3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 09:29:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:52926 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab3JJN3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 09:29:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1072,1371106800"; 
   d="scan'208";a="417220218"
Date: Thu, 10 Oct 2013 15:26:25 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [REPOST/PATCH] mfd: tps65910: remove warning during dt node
 parsing
Message-ID: <20131010132625.GA3942@zurbaran>
References: <1348663684-1377-1-git-send-email-ldewangan@nvidia.com>
 <CAOesGMjQ=RfKVxpBAfFAanb5bXuwgNtL+fwDaJGNVXQgyTneKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMjQ=RfKVxpBAfFAanb5bXuwgNtL+fwDaJGNVXQgyTneKw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On Wed, Oct 09, 2013 at 05:51:14PM -0700, Olof Johansson wrote:
> Hi,
> 
> On Wed, Sep 26, 2012 at 5:48 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> > Driver throw the warning message if dt node does not
> > have the info for VMBCH-Threshold and VMBCH2-Threshold.
> > These properties are optional property and hence it
> > is not mandatory to have these on DT node and in this case
> > it should not throw the warning message.
> > It creates noise from driver as follows:
> > [    0.384605] tps65910 4-002d: VMBCH-Threshold not specified
> > [    0.384616] tps65910 4-002d: VMBCH2-Threshold not specified
> >
> > Removing the warning message from driver.
> >
> > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> > ---
> > It seems orginal patch has been lost. Reposting it.
> 
> I still see this with 3.12-rc. Sam?
I can take it through mfd-next, but do you really think it's material
for mfd-fixes ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
