Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab3AYUdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:33:01 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39457 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3AYUc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:32:58 -0500
Date: Fri, 25 Jan 2013 12:32:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver-core: remove the duplicate assignment of
 kobj->parent in device_add
Message-ID: <20130125203256.GA6374@kroah.com>
References: <1358920710-23147-1-git-send-email-weiyang@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358920710-23147-1-git-send-email-weiyang@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 01:58:30PM +0800, Wei Yang wrote:
> kobject_add() will setup the kobject parent correctly.

How so?

> This patch removes the redundant code.

I don't know, how is it redundant?  What is this causing?  Is it somehow
slowing things down?

> Tested on Lenovo T420.

How?

I don't know about this patch, sorry.

greg k-h
