Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935549Ab3FUATn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:19:43 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:42447 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935359Ab3FUATl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:19:41 -0400
Date: Fri, 21 Jun 2013 02:19:33 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: sasha.levin@oracle.com
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: FMC: BUG: scheduling while atomic on boot
Message-ID: <20130621001933.GA12353@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <51C390FA.3080302@oracle.com>
References: <51C390FA.3080302@oracle.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> I compiled FMC in to test it out, but when booting with it I get:

Thank you for your report.  I'll take a look tomorrow.  I admit I only
use it as a module (I'm on it even now, working on an ADC FMC board).

Thanks again, I'll have a fix ASAP

/alessandro
