Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab3IYXEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:04:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab3IYXEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:04:04 -0400
Date: Wed, 25 Sep 2013 16:04:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: dgnc: driver.c: casting (void *)value returned
 by kzalloc is useless
Message-ID: <20130925230403.GA4863@kroah.com>
References: <52285D8B.3050106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52285D8B.3050106@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 06:31:39PM +0800, Duan Jiong wrote:
> From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
> 
> Casting (void *) value returned by kzalloc is useless
> as mentioned in Documentation/CodingStyle, Chap 14.
> 
> Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>

No longer applies, please redo against the latest linux-next release.

thanks,

greg k-h
