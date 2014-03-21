Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965610AbaCUCdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 22:33:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965355AbaCUCdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 22:33:42 -0400
Date: Thu, 20 Mar 2014 19:35:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: shaun@xresource.ca, sachin.kamat@linaro.org, ebru.akagunduz@gmail.com,
        dulshani.gunawardhana89@gmail.com, speiro@ai2.upv.es,
        gulsah.1004@gmail.com, himangi774@gmail.com,
        peter.p.waskiewicz.jr@intel.com, fempsci@gmail.com,
        nandu.hgowda@gmail.com, sima.baymani@gmail.com,
        viro@zeniv.linux.org.uk, dhowells@redhat.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        tklauser@distanz.ch
Subject: Re: [PATCH] staging: cxt1e1: replace kmalloc/kfree with
 OS_kmalloc/OS_kfree
Message-ID: <20140321023505.GA17404@kroah.com>
References: <1438070.BphUZIHYWT@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1438070.BphUZIHYWT@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 10:41:39AM +0900, Daeseok Youn wrote:
> 
> Replace kmalloc/kfree with OS_kmalloc/OS_kfree.

I think you mean this the other way around, right?

