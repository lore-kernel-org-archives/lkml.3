Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbaEELf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 07:35:28 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26444 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452AbaEELf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 07:35:26 -0400
Date: Mon, 5 May 2014 14:35:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Martin Kepplinger <martink@posteo.de>
Cc: gregkh@linuxfoundation.org, lidza.louina@gmail.com,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] staging: dgnc: use dev_err() instead of printk()
Message-ID: <20140505113507.GP26890@mwanda>
References: <1398765250-16064-1-git-send-email-martink@posteo.de>
 <1399285779-7040-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399285779-7040-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 12:29:39PM +0200, Martin Kepplinger wrote:
> Use dev_err() instead of printk() and remove "dgnc:" from the message.
> This should provide userspace with more useful information and use
> the common kernel coding style.
> 

Whenever I see a "RESEND" in a subject and no explanation then it means
our development process has broken down.  Meanwhile this is the first
time I have seen this patch so the problem is not on our side.

regards,
dan carpenter

