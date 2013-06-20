Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab3FTOJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:09:56 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:41676 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755028Ab3FTOJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:09:55 -0400
Date: Thu, 20 Jun 2013 16:09:47 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: dan.carpenter@oracle.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] FMC: fix error handling in probe() function
Message-ID: <20130620140947.GA9773@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20130620081018.GB15095@elgon.mountain>
References: <20130620081018.GB15095@elgon.mountain> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The call to kzalloc() wasn't checked.
> The dev_info() message dereferenced freed memory on error.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Alessandro Rubini <rubini@gnudd.com>

Thanks!

