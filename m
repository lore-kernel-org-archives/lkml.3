Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761892Ab3JQApJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 20:45:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:64508 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760835Ab3JQApH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 20:45:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,510,1378882800"; 
   d="scan'208";a="394113270"
Subject: Re: [PATCH v2] USB: cdc-acm: put delayed_wb to list
From: Xiao Jin <jin.xiao@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: oliver@neukum.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20131016204433.GA10535@kroah.com>
References: <1381798895-2980-1-git-send-email-jin.xiao@intel.com>
	 <20131016204433.GA10535@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Oct 2013 08:56:07 +0800
Message-ID: <1381971367.15186.2.camel@xiaojin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Greg,

I am sorry for the inconvenience again. I will do as what you point to
make sure the thing won't happen again in future.

On Wed, 2013-10-16 at 13:44 -0700, Greg KH wrote:
> On Tue, Oct 15, 2013 at 09:01:35AM +0800, xiao jin wrote:
> > If acm_write_start during acm suspend, write acm_wb is backuped
> > to delayed_wb. When acm resume, the delayed_wb will be started.
> > This mechanism can only record one write during acm suspend. More
> > acm write will be abandoned.
> > 
> > This patch is to use list_head to record the write acm_wb during acm
> > suspend. It can ensure no acm write abandoned.
> > 
> > Signed-off-by: xiao jin <jin.xiao@intel.com>
> 
> You obviously did not test this patch at all, as it breaks the build.
> 
> Please get a senior Intel kernel developer to sign-off on your future
> patches so this does not happen again.
> 
> greg k-h


