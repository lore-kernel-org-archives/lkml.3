Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab3CJPn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 11:43:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17984 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3CJPn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 11:43:28 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=lTS-ss-zTAkA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=ywnzNTuzcLMA:10 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=5Tto6a8WAAAA:8 a=teZLUl3CQOirfboXSOcA:9 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Sun, 10 Mar 2013 11:43:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lock() -> Where is this defined?
Message-ID: <20130310154327.GF9161@home.goodmis.org>
References: <1362929420.1220.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362929420.1220.11.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 04:30:20PM +0100, Thomas Meyer wrote:
> Hi,
> 
> in include/linux/lockdep.h:
> 
> #define LOCK_CONTENDED(_lock, try, lock) \
                                      ^
				      |
				    here

-- Steve

>     lock(_lock)
> 
> Where is this lock() function defined?
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
