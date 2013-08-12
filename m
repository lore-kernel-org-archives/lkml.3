Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab3HLMpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 08:45:06 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:46431 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756030Ab3HLMpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 08:45:05 -0400
Date: Mon, 12 Aug 2013 14:44:54 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: jg1.han@samsung.com
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] FMC: Staticize local symbols
Message-ID: <20130812124454.GA22479@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <000001ce970d$085302b0$18f90810$@samsung.com>
References: <000001ce970d$085302b0$18f90810$@samsung.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This local symbol is used only in this file.
> Fix the following sparse warnings:

Thanks!

Acked-by: Alessandro Rubini <rubini@gnudd.com>

/alessandro
