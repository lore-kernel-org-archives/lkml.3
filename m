Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3CVKnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:43:31 -0400
Received: from sauhun.de ([89.238.76.85]:57950 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897Ab3CVKn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:43:29 -0400
Date: Fri, 22 Mar 2013 11:43:23 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: =?utf-8?B?7Iah7J2A67SJ?= <eunb.song@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: I2C: Fix i2c fail problem when a process is terminated by a
 signal on octeon in 3.8
Message-ID: <20130322104323.GF8240@the-dreams.de>
References: <16202598.147281361912922998.JavaMail.weblogic@epml02>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16202598.147281361912922998.JavaMail.weblogic@epml02>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 09:08:43PM +0000, 송은봉 wrote:
> 
> I've been debugging the abnormal operation of i2c on octeon. 
> If a process is terminated by signal in the middle of i2c operation, 
> next i2c read operation which is done by another process was failed.
> So i changed to ignore signal in the middle of i2c operation. 
> After that the problem was not reproduced.
> 
>  
> 
> Signed-off-by: EunBong Song <eunb.song@samsung.com>

Basically OK, but you have lots of whitespace issues, so I can't apply
your patch. Please resend and make sure it applies.

Thanks,

   Wolfram
