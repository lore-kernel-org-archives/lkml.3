Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3COTU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:20:29 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:55901 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3COTU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:20:27 -0400
Date: Fri, 15 Mar 2013 12:20:24 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "Li, Fei" <fei.li@intel.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>
Subject: Re: [PATCH] pm: print the name of failed suspend function for
 platform device
Message-ID: <20130315192024.GB11988@kroah.com>
References: <1360041183.15311.2.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <27240C0AC20F114CBF8149A2696CBE4A254DD3@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A254DD3@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 01:41:28AM +0000, Liu, Chuansheng wrote:
> Hi Greg,
> 
> I just noticed some other cases need the more log also.
> https://lkml.org/lkml/2013/3/8/71
> 
> Could you consider the below patch, thanks?

Didn't I already consider it and respond?

