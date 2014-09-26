Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbaIZPpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:45:45 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:50954 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbaIZPpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:45:43 -0400
Date: Fri, 26 Sep 2014 08:45:36 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable@vger.kernel.org, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 000/142] 3.12.29-stable review
Message-ID: <20140926154536.GA7174@roeck-us.net>
References: <cover.1411724723.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 11:45:33AM +0200, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.29 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue Sep 30 11:45:24 CEST 2014.
> Anything received after that time might be too late.
> 

Hi Jiri,

Build results:
	total: 135 pass: 135 fail: 0

Qemu test results:
	total: 21 pass: 21 fail: 0

Both obviously look good, however my tree doesn't match your review request.
It includes 245 patches instead of just 142.

Looks like your tree is a bit ahead of time, so I guess that is ok.
Is there a way for me to avoid this when pulling in your pending changes ?
So far I pull the changes from the stable-3.12-queue branch in your
repository at kernel.org.

Thanks,
Guenter
