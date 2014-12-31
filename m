Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaLaDEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 22:04:38 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43265 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaLaDEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 22:04:37 -0500
Date: Tue, 30 Dec 2014 19:04:35 -0800
From: Serguey Parkhomovsky <sergueyparkhomovsky@gmail.com>
To: Jeremiah Mahler <jmmahler@gmail.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: linux-prim.c: fix sparse warnings about
 static declaration
Message-ID: <20141231030435.GA3775@fedora.localdomain>
References: <20141229111032.GA18686@fedora.localdomain>
 <20141230223518.GA31616@hudson.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141230223518.GA31616@hudson.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2014 at 02:35:18PM -0800, Jeremiah Mahler wrote:
> 
> If you look at the source code just below these functions you will find:
> 
> EXPORT_SYMBOL(libcfs_arch_init);
> EXPORT_SYMBOL(libcfs_arch_cleanup);
> 
> So making these static is incorrect because they are being used outside
> of this file.
> 

Thanks for the review, and sorry about the noise; I'll be more careful next time.

Serguey
