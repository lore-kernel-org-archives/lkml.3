Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaJAMdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 08:33:15 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26105 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaJAMdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 08:33:14 -0400
Date: Wed, 1 Oct 2014 15:33:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Somya Anand <somyaanand214@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Android: alarm-dev: Fixed a y2038 issue
Message-ID: <20141001123304.GD23154@mwanda>
References: <1412181986-4507-1-git-send-email-somyaanand214@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412181986-4507-1-git-send-email-somyaanand214@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 10:16:26PM +0530, Somya Anand wrote:
> Fixed y2038 issue by replacing timespec with timespec64.
> 

This breaks the userspace API.

regards,
dan carpenter

