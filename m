Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaJSR0K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 13:26:10 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:45934 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaJSR0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 13:26:06 -0400
MIME-Version: 1.0
In-Reply-To: <20141019.124542.141206969262552652.davem@davemloft.net>
References: <1413672385-8492-1-git-send-email-dg@emlix.com>
	<1413672545-8535-1-git-send-email-dg@emlix.com>
	<20141019.124542.141206969262552652.davem@davemloft.net>
Date: Sun, 19 Oct 2014 21:26:05 +0400
Message-ID: <CAMo8BfJ-wvDoDmm+HLHvC3VRUshdqU4eJchOGYt_YJsUktap8Q@mail.gmail.com>
Subject: Re: [PATCH] net: s6gmac: remove driver
From: Max Filippov <jcmvbkbc@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: =?UTF-8?Q?Daniel_Gl=C3=B6ckner?= <dg@emlix.com>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 8:45 PM, David Miller <davem@davemloft.net> wrote:
> From: Daniel Glöckner <dg@emlix.com>
> Date: Sun, 19 Oct 2014 00:49:05 +0200
>
>> The s6000 Xtensa support is removed from the kernel. There are no
>> other chips using this driver.
>
> That's not what I see in Linus's current tree:

David, s6000 removal is queued for 3.18.

-- 
Thanks.
-- Max
