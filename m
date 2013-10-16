Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761885Ab3JPUof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:44:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760952Ab3JPUoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:44:34 -0400
Date: Wed, 16 Oct 2013 13:44:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: xiao jin <jin.xiao@intel.com>
Cc: oliver@neukum.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] USB: cdc-acm: put delayed_wb to list
Message-ID: <20131016204433.GA10535@kroah.com>
References: <1381798895-2980-1-git-send-email-jin.xiao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381798895-2980-1-git-send-email-jin.xiao@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 09:01:35AM +0800, xiao jin wrote:
> If acm_write_start during acm suspend, write acm_wb is backuped
> to delayed_wb. When acm resume, the delayed_wb will be started.
> This mechanism can only record one write during acm suspend. More
> acm write will be abandoned.
> 
> This patch is to use list_head to record the write acm_wb during acm
> suspend. It can ensure no acm write abandoned.
> 
> Signed-off-by: xiao jin <jin.xiao@intel.com>

You obviously did not test this patch at all, as it breaks the build.

Please get a senior Intel kernel developer to sign-off on your future
patches so this does not happen again.

greg k-h
