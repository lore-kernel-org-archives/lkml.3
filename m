Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbaCRXLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:11:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758496AbaCRXKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:10:53 -0400
Date: Tue, 18 Mar 2014 16:12:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Matei Oprea <eu@opreamatei.ro>
Cc: sachin.kamat@linaro.org, shaun@xresource.ca, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>
Subject: Re: [PATCH] staging: cxt1e1: hwprobe: Fix sparse warning
Message-ID: <20140318231256.GB2327@kroah.com>
References: <1395181999-29433-1-git-send-email-eu@opreamatei.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395181999-29433-1-git-send-email-eu@opreamatei.ro>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 12:33:19AM +0200, Matei Oprea wrote:
> This fixes the following sparse warning:
> * drivers/staging/cxt1e1/hwprobe.c:43:19: 
> warning: symbol 'hdw_info' was not declared. Should it be static?
> * drivers/staging/cxt1e1/hwprobe.c:47:1: 
> warning: symbol 'show_two' was not declared. Should it be static?
> * drivers/staging/cxt1e1/hwprobe.c:99:1: 
> warning: symbol 'hdw_sn_get' was not declared. Should it be static?
> *drivers/staging/cxt1e1/hwprobe.c:149:1: 
> warning: symbol 'prep_hdw_info' was not declared. Should it be static?
> * drivers/staging/cxt1e1/hwprobe.c:169:1: 
> warning: symbol 'cleanup_ioremap' was not declared. Should it be static?
> * drivers/staging/cxt1e1/hwprobe.c:195:1: 
> warning: symbol 'cleanup_devs' was not declared. Should it be static?
> drivers/staging/cxt1e1/hwprobe.c:293:1: 
> * warning: symbol 'c4hw_attach_all' was not declared. Should it be static?

Please don't line-wrap sparse or compiler warnings, it just looks messy.
