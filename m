Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaAXIWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:22:04 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57370 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbaAXIWB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:22:01 -0500
MIME-Version: 1.0
In-Reply-To: <20140124080451.GD7444@mwanda>
References: <20140123224400.GA8124@rashika>
	<20140124080451.GD7444@mwanda>
Date: Fri, 24 Jan 2014 13:52:00 +0530
Message-ID: <CAMpEsFFkb13RuiJMxB80MS6dEmzJ4XJVTTOev1veSvxVpyY0zw@mail.gmail.com>
Subject: Re: [PATCH] drivers: staging: Mark functions as static and remove
 unused function in bpctl_mod.c
From: Rashika Kheria <rashika.kheria@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
        driverdev <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        =?UTF-8?B?VMO8bGluIMSwemVy?= <tulinizer@gmail.com>,
        Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 1:34 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Fri, Jan 24, 2014 at 04:14:00AM +0530, Rashika Kheria wrote:
>> Mark functions as static in bpctl_mod.c because they are not used
>> outside this file. Remove unused function from bpctl_mod.c.
>>
>> This also eliminates the following warnings from bpctl_mod.c:
>> drivers/staging/silicom/bpctl_mod.c:1507:6: warning: no previous prototype for ‘send_bypass_clear_pulse’ [-Wmissing-prototypes]
>> drivers/staging/silicom/bpctl_mod.c:1762:5: warning: no previous prototype for ‘cmnd_on’ [-Wmissing-prototypes]
>
> Don't do these massive text blocks.  Just put one or two of the errors
> so we get the idea.
>

Sure.

Thanks,
-- 
Rashika Kheria
B.Tech CSE
IIIT Hyderabad
