Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaBYMbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:31:20 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35897 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbaBYMbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:31:18 -0500
Message-ID: <530C8D00.8070606@ti.com>
Date: Tue, 25 Feb 2014 07:30:56 -0500
From: Tom Rini <trini@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Josh Triplett <josh@joshtriplett.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] checkpatch.pl: Add warning for new __packed additions
References: <1393274296-26179-1-git-send-email-trini@ti.com>  <1393275606.11020.59.camel@joe-AO722> <530BB571.8080509@ti.com>  <1393277304.11020.64.camel@joe-AO722> <530BBF10.6050601@ti.com>  <1393279377.11020.66.camel@joe-AO722> <530BC209.2000708@ti.com>  <1393279691.11020.69.camel@joe-AO722> <530BC5A4.4060803@ti.com>  <1393281098.11020.82.camel@joe-AO722> <530BCB27.5040808@ti.com> <1393305803.11020.119.camel@joe-AO722>
In-Reply-To: <1393305803.11020.119.camel@joe-AO722>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 12:23 AM, Joe Perches wrote:
> On Mon, 2014-02-24 at 17:43 -0500, Tom Rini wrote:
>> My perl is quite limited, so however much effort you're interested in
>> putting in here is greatly appreciated (even if it's pointing out
>> something else already in the script to copy and modify).  We already
>> ship a .checkpatch.conf so having to enable something by default is
>> fine.  Thanks!
> 
> The U-Boot checkpatch is not the same as the current
> linux version and would need updating.
> 
> Tell me a little more please about how often or possible
> it would be to update the current linux version of
> checkpatch to the version used in U-Boot.

The only intentional differences we have today are adding debug/printf
to the list of log functions and pointing people at boards.cfg not
CHECKPATCH in MAINTAINERS, so I can re-sync us no problem as, yup, we're
about a year out of date there.  Oh and I see now someone snuck in a
check for whitespace before semi-colon to catch 'return 0 ;' which I'll
check real quick isn't something already caught and if not post that as
well.

-- 
Tom
