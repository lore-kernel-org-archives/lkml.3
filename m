Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaEFX1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 19:27:24 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:43748 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaEFX1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 19:27:23 -0400
Message-ID: <1399418839.15399.106.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
From: Eric Dumazet <eric.dumazet@gmail.com>
To: josh@joshtriplett.org
Cc: David Miller <davem@davemloft.net>, xiyou.wangcong@gmail.com,
        andi@firstfloor.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com,
        ak@linux.intel.com
Date: Tue, 06 May 2014 16:27:19 -0700
In-Reply-To: <20140506225039.GA22331@cloud>
References: <CAM_iQpUgj7BqpzRL070DEGQ32SWwN68BRgM5DtFqvBLjGGOLQA@mail.gmail.com>
	 <20140506.164410.15377655213427639.davem@davemloft.net>
	 <20140506210815.GB21791@cloud>
	 <20140506.171117.1365037653422161013.davem@davemloft.net>
	 <20140506225039.GA22331@cloud>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-06 at 15:50 -0700, josh@joshtriplett.org wrote:

> There's something very wrong if 2.4.x works for
> cases that 3.x doesn't; that would be a serious regression.

You'll have to ask Linus to bring back i386 support then,
I believe it was removed in 3.8



