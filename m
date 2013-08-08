Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966406Ab3HHUc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:32:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42534 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968Ab3HHUc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:32:26 -0400
Date: Thu, 8 Aug 2013 23:32:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: gregkh@linuxfoundation.org, Linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-Devel <devel@driverdev.osuosl.org>
Subject: Re: [PATCH 1/2] Staging: BCM: removed whitespaces and Errors.
Message-ID: <20130808203212.GB5502@mwanda>
References: <5203CF41.4040607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5203CF41.4040607@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This breaks the compile.

It's doing too many things at once as well.  Do one type of white
space fix at a time.

regards,
dan carpenter

