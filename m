Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab3CSN3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:29:48 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:61771 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab3CSN3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:29:46 -0400
Date: Tue, 19 Mar 2013 06:31:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dong Hao <haodong@linux.vnet.ibm.com>
Cc: xiaoguangrong@linux.vnet.ibm.com, shangw@linux.vnet.ibm.com,
        weiyang@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] lib/kobject: simplify the kobject_init function
Message-ID: <20130319133104.GB24313@kroah.com>
References: <1363675621-31186-1-git-send-email-haodong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363675621-31186-1-git-send-email-haodong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 02:46:59PM +0800, Dong Hao wrote:
> From: Dong Hao <haodong@linux.vnet.ibm.com>
> 
> The printk() function at the end of function kobject_init() already had '\n',
> so remove the duplicated one.

Your subject doesn't match this description.
