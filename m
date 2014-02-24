Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaBXWFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:05:19 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44303 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbaBXWFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:05:18 -0500
Message-ID: <530BC209.2000708@ti.com>
Date: Mon, 24 Feb 2014 17:04:57 -0500
From: Tom Rini <trini@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Josh Triplett <josh@joshtriplett.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] checkpatch.pl: Add warning for new __packed additions
References: <1393274296-26179-1-git-send-email-trini@ti.com>  <1393275606.11020.59.camel@joe-AO722> <530BB571.8080509@ti.com>  <1393277304.11020.64.camel@joe-AO722> <530BBF10.6050601@ti.com> <1393279377.11020.66.camel@joe-AO722>
In-Reply-To: <1393279377.11020.66.camel@joe-AO722>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 05:02 PM, Joe Perches wrote:
> On Mon, 2014-02-24 at 16:52 -0500, Tom Rini wrote:
>> I've been lead to
>> believe that most cases now people should be using regmap instead, which
>> just leaves the case of having to match on-disk formats or similar cases
>> I believe as the things that must stay __packed.
> 
> __packed is also necessary for on-wire networking protocols.

Indeed, and there's probably a few other valid cases I'm also
forgetting.  But the common case is hardware, where regmap is now preferred.

I've got this modified to a CHK and only for non-file usage.  Anything
else we want to talk about before I repost?

-- 
Tom
