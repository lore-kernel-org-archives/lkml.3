Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbaDVJqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:46:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39497 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbaDVJqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:46:12 -0400
Date: Tue, 22 Apr 2014 12:45:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kumar Gaurav <kumargauravgupta3@gmail.com>
Cc: gregkh@linuxfoundation.org, lidza.louina@gmail.com,
        devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging:dgap:dgap_tty.c: Upgraded driver to use Mutex
 instead of semaphore
Message-ID: <20140422094555.GD26890@mwanda>
References: <1397750132-21296-1-git-send-email-kumargauravgupta3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397750132-21296-1-git-send-email-kumargauravgupta3@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 09:25:32PM +0530, Kumar Gaurav wrote:
> dgap driver uses semaphore for obtaining lock. I upgraded it to use MUTEX.
> 

You are patching ancient code that doesn't exist.  Work against
linux-next.

regards,
dan carpenter

