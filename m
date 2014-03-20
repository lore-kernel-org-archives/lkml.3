Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbaCTQ6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:58:16 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:56480 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758756AbaCTQ6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:58:11 -0400
Date: Thu, 20 Mar 2014 09:58:07 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kernel@stlinux.com,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Angus CLARK <angus.clark@st.com>
Subject: Re: [PATCH 1/5] mtd: st_spi_fsm: Remove useless consts from function
 arguments
Message-ID: <20140320165807.GV31517@norris-Latitude-E6410>
References: <1395313907-25318-1-git-send-email-lee.jones@linaro.org>
 <1395313907-25318-2-git-send-email-lee.jones@linaro.org>
 <1395314713.7776.17.camel@joe-AO722>
 <20140320114123.GE21349@lee--X1>
 <1395316090.7776.24.camel@joe-AO722>
 <20140320115412.GU31517@norris-Latitude-E6410>
 <20140320120307.GA9240@lee--X1>
 <1395317630.7776.29.camel@joe-AO722>
 <CAN8TOE9g2VwVgVx1Sj3OcguuwP_A9pJS+WpgTAL49KyN9r1CiA@mail.gmail.com>
 <1395319485.7776.32.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395319485.7776.32.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 05:44:45AM -0700, Joe Perches wrote:
> On Thu, 2014-03-20 at 05:41 -0700, Brian Norris wrote:
> > I also don't think that a function parameter is the right place to
> > mark const like this. Function arguments are always pass-by-value, so
> > this 'const' tells users (callers) nothing useful. It only provides
> > useless constraints on what the function can do with its copy of the
> > parameter.
> 
> Again, that's not useless information.

For local, pass-by-value function arguments (i.e., constant data, or
constant pointers to data), I respectfully disagree. (For "pointers to
constant data", I completely agree that the 'const' info is useful.)

> And as you've seen, just making these changes
> can be error prone.

Thank you for catching our mistake now. But I don't think that is
relevant; just because you caught an error doesn't mean that the change
(primarily for consistency's sake) should be avoided entirely.

Unless you have a more convincing argument, this code will remain as-is.

Regards,
Brian
