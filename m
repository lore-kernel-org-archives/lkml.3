Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbaCTXTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 19:19:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759537AbaCTXTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 19:19:22 -0400
Date: Thu, 20 Mar 2014 16:19:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roger <rogerable@realtek.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <driverdev-devel@linuxdriverproject.org>,
        <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>
Subject: Re: [PATCH v4 3/3] memstick: Add realtek USB memstick host driver
Message-Id: <20140320161920.256afa8c21ac8f28e6c029b5@linux-foundation.org>
In-Reply-To: <532AA8EB.3010206@realtek.com>
References: <1392199238-14500-1-git-send-email-rogerable@realtek.com>
	<1392199238-14500-4-git-send-email-rogerable@realtek.com>
	<532AA8EB.3010206@realtek.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014 16:38:03 +0800 Roger <rogerable@realtek.com> wrote:

> On 02/12/2014 06:00 PM, rogerable@realtek.com wrote:
> > From: Roger Tseng <rogerable@realtek.com>
> >
> > Realtek USB memstick host driver provides memstick host support based on the
> > Realtek USB card reader MFD driver.
> >
> > Signed-off-by: Roger Tseng <rogerable@realtek.com>
> Andrew,
> 
> Would you please Ack or comment this patch(3/3) to let the 3 patches be 
> merged together? I have been making the same request at the message 
> thread of "[PATCH v4 2/3]" since several weeks ago but got no response. 
> Thus I re-post here and hope I could get something.
> 

Looks OK to me - I had a few minor quibbles.  Please proceed in that
way.

It would be nice if Alex and/or Maxim had time to look through the code.
