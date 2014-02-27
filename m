Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaB0UdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:33:25 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44423 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaB0UdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:33:24 -0500
Message-ID: <530FA0FF.9010202@ti.com>
Date: Thu, 27 Feb 2014 15:33:03 -0500
From: Tom Rini <trini@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Josh Triplett <josh@joshtriplett.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] checkpatch.pl: Add warning for new __packed additions
References: <1393274296-26179-1-git-send-email-trini@ti.com>  <1393275606.11020.59.camel@joe-AO722> <530BB571.8080509@ti.com>  <1393277304.11020.64.camel@joe-AO722> <530BBF10.6050601@ti.com>  <1393279377.11020.66.camel@joe-AO722> <530BC209.2000708@ti.com>  <1393279691.11020.69.camel@joe-AO722> <530BC5A4.4060803@ti.com>  <1393281098.11020.82.camel@joe-AO722> <530BCB27.5040808@ti.com>  <1393305803.11020.119.camel@joe-AO722> <530C8D00.8070606@ti.com> <1393452256.24588.5.camel@joe-AO722>
In-Reply-To: <1393452256.24588.5.camel@joe-AO722>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 05:04 PM, Joe Perches wrote:
> On Tue, 2014-02-25 at 07:30 -0500, Tom Rini wrote:
>> The only intentional differences we have today are adding debug/printf
>> to the list of log functions
> 
> That seems fine and trivial to keep current.

Agreed,

>> and pointing people at boards.cfg not
>> CHECKPATCH in MAINTAINERS,
> 
> That seems wrong.
> 
> The idea of that message is to fix defects in checkpatch,
> not any other code.
> 
> Maybe that could be reworded to
> "See the CHECKPATCH entry in the MAINTAINERS file of linux git"
> or some such.

I've dropped that change now in a re-sync to current checkpatch.pl.
Happy to pull in a re-wording of this part from a near-future resync
with the kernel :)

-- 
Tom
