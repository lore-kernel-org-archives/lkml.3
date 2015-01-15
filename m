Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbbAOHDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 02:03:23 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:58211 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbbAOHDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 02:03:21 -0500
Message-ID: <1421305399.11734.40.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: PROBLEM: [3.4] neigh_destroy() crashes on unplug netdev.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nakashima Akihiro <Nakashima.Akihiro@exc.epson.co.jp>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ueda Motoki <Ueda.Motoki@exc.epson.co.jp>,
        Otsu Takahiro <Otsu.Takahiro@exc.epson.co.jp>,
        Tomono Mitsunori <Tomono.Mitsunori@exc.epson.co.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 14 Jan 2015 23:03:19 -0800
In-Reply-To: <E694983F62A0954788A62E997021A9C31093E1@JPEX011.apo.epson.net>
References: <E694983F62A0954788A62E997021A9C31093E1@JPEX011.apo.epson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-15 at 05:57 +0000, Nakashima Akihiro wrote:
> Dear David and networking developers:
> 
> I got kernel panic on 3.4.105 kernel.
> Please see a report below.

Please try a recent kernel.

We are not going to debug such an old one, given there are chances we
already fixed the problem ages ago.

Thanks



