Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab3CSNaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:30:19 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:50217 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab3CSNaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:30:16 -0400
Date: Tue, 19 Mar 2013 06:31:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dong Hao <haodong@linux.vnet.ibm.com>
Cc: xiaoguangrong@linux.vnet.ibm.com, shangw@linux.vnet.ibm.com,
        weiyang@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] lib/kobject: WARN_ON corresponds to BUG_ON
Message-ID: <20130319133135.GC24313@kroah.com>
References: <1363675621-31186-1-git-send-email-haodong@linux.vnet.ibm.com>
 <1363675621-31186-3-git-send-email-haodong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363675621-31186-3-git-send-email-haodong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 02:47:01PM +0800, Dong Hao wrote:
> From: Dong Hao <haodong@linux.vnet.ibm.com>
> 
> WARN_ON corresponds to BUG_ON and also gets more info.

Huh?  No.

Please stop, don't resend these.

greg k-h
