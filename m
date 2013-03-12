Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3CLABf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:01:35 -0400
Received: from intranet.asianux.com ([58.214.24.6]:34325 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab3CLABe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:01:34 -0400
X-Spam-Score: -100.8
Message-ID: <513E7043.4090304@asianux.com>
Date: Tue, 12 Mar 2013 08:01:07 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: David Miller <davem@davemloft.net>, mgherzan@gmail.com,
        nschichan@freebox.fr, daniel.borkmann@tik.ee.ethz.ch,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM:net: an issue for k which is u32, never < 0
References: <513BECDA.3030803@asianux.com> <20130310.171238.330349067962026661.davem@davemloft.net> <20130311164741.GL4977@n2100.arm.linux.org.uk>
In-Reply-To: <20130311164741.GL4977@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月12日 00:47, Russell King - ARM Linux 写道:
> On Sun, Mar 10, 2013 at 05:12:38PM -0400, David Miller wrote:
>> > From: Chen Gang <gang.chen@asianux.com>
>> > Date: Sun, 10 Mar 2013 10:15:54 +0800
>> > 
>>> > > 
>>> > >   k is u32 which never < 0, need type cast, or cause issue.
>>> > > 
>>> > > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> > 
>> > Who will apply this, ARM folks or me?
> I'm happy if you wish to take the patch:
> 
> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> Thanks.
> 
> 

  thank you very much.

  :-)

-- 
Chen Gang

Asianux Corporation
