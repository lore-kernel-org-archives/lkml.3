Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaJSR2G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 13:28:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55036 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaJSR2D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 13:28:03 -0400
Date: Sun, 19 Oct 2014 13:28:01 -0400 (EDT)
Message-Id: <20141019.132801.424495087167944921.davem@davemloft.net>
To: jcmvbkbc@gmail.com
Cc: dg@emlix.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: s6gmac: remove driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMo8BfJ-wvDoDmm+HLHvC3VRUshdqU4eJchOGYt_YJsUktap8Q@mail.gmail.com>
References: <1413672545-8535-1-git-send-email-dg@emlix.com>
	<20141019.124542.141206969262552652.davem@davemloft.net>
	<CAMo8BfJ-wvDoDmm+HLHvC3VRUshdqU4eJchOGYt_YJsUktap8Q@mail.gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Oct 2014 10:28:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>
Date: Sun, 19 Oct 2014 21:26:05 +0400

> On Sun, Oct 19, 2014 at 8:45 PM, David Miller <davem@davemloft.net> wrote:
>> From: Daniel Glöckner <dg@emlix.com>
>> Date: Sun, 19 Oct 2014 00:49:05 +0200
>>
>>> The s6000 Xtensa support is removed from the kernel. There are no
>>> other chips using this driver.
>>
>> That's not what I see in Linus's current tree:
> 
> David, s6000 removal is queued for 3.18.

Then there is zero reason for me to apply this to my networking
tree.
