Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab3CKEx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 00:53:29 -0400
Received: from intranet.asianux.com ([58.214.24.6]:42592 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab3CKEx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 00:53:28 -0400
X-Spam-Score: -100.8
Message-ID: <513D632C.7030709@asianux.com>
Date: Mon, 11 Mar 2013 12:53:00 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux@arm.linux.org.uk, mgherzan@gmail.com, nschichan@freebox.fr,
        daniel.borkmann@tik.ee.ethz.ch, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM:net: an issue for k which is u32, never < 0
References: <513BECDA.3030803@asianux.com> <20130310.171238.330349067962026661.davem@davemloft.net>
In-Reply-To: <20130310.171238.330349067962026661.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月11日 05:12, David Miller 写道:
> From: Chen Gang <gang.chen@asianux.com>
> Date: Sun, 10 Mar 2013 10:15:54 +0800
> 
>> > 
>> >   k is u32 which never < 0, need type cast, or cause issue.
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Who will apply this, ARM folks or me?
> 
> 

  sorry I don't know, either. I get the mail addresses by
./scripts/get_maintainers.pl. it includes you.

  if no others reply within a week, I hope you can help to check and
apply it.

  thanks.

-- 
Chen Gang

Asianux Corporation
