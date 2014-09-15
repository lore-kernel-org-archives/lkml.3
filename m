Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbaIOIYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 04:24:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25472 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbaIOIYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 04:24:39 -0400
Date: Mon, 15 Sep 2014 11:23:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: lustre: libcfs: debug.c: Cleaning up
 unnecessary use of memset in conjunction with strncpy
Message-ID: <20140915082346.GB17875@mwanda>
References: <1410710597-14520-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410710597-14520-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2014 at 06:03:16PM +0200, Rickard Strandqvist wrote:
> Using memset before strncpy just to ensure a trailing null
> character is an unnecessary double writing of a string
> 

You really should make a function which pads and NUL terminates.

I've said this before, of course, but you haven't even tried.

I can't get excited about these cleanups which open code NUL termination
every where.  They are risky and have introduced bugs before.

regards,
dan carpenter
