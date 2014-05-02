Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaEBH3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 03:29:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41785 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaEBH3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 03:29:20 -0400
Date: Fri, 2 May 2014 10:29:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Karim Raslan <karim.allah.ahmed@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        SeongJae Park <sj38.park@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Cruz Julian Bishop <cruzjbishop@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixing coding style issues in android alarm-dev.c
Message-ID: <20140502072905.GA4963@mwanda>
References: <1398891959-10437-1-git-send-email-karim.allah.ahmed@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398891959-10437-1-git-send-email-karim.allah.ahmed@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 10:05:53PM +0100, Karim Raslan wrote:
> fixing "Missing a blank line after declarations" found by checkpatch.pl script
> 

Use a subject prefix.  Also the subject is too vague.

[PATCH] staging: android: alarm-dev: add a blank line

regards,
dan carpenter

