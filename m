Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374Ab3CVOWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:22:08 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:39225 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab3CVOWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:22:05 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] phy: Add XGMII phy interface type
From: Ben Collins <benmcollins13@gmail.com>
In-Reply-To: <20130322.101900.1947638393872492900.davem@davemloft.net>
Date: Fri, 22 Mar 2013 10:22:05 -0400
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9CC1FA76-1620-4E0F-82DC-89535633329F@gmail.com>
References: <E1UJ1fR-0004hy-AI@swissweb.swissdisk.com> <20130322.101259.1120794715082991238.davem@davemloft.net> <5BDCE647-67A3-423B-AB9C-8C50CC0B6C02@gmail.com> <20130322.101900.1947638393872492900.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 22, 2013, at 10:19 AM, David Miller <davem@davemloft.net> wrote:

> From: Ben Collins <benmcollins13@gmail.com>
> Date: Fri, 22 Mar 2013 10:17:35 -0400
> 
>> On Mar 22, 2013, at 10:12 AM, David Miller <davem@davemloft.net> wrote:
>> 
>>> From: Ben Collins <ben.c@servergy.com>
>>> Date: Mon, 18 Mar 2013 19:53:42 -0400
>>> 
>>>> Used by systems based on certain Freescale SoCs (specifically the
>>>> Servergy CTS-1000 system).
>>>> 
>>>> Signed-off-by: Ben Collins <ben.c@servergy.com>
>>> 
>>> You can resubmit this patch when you submit a driver upstream that
>>> uses it, so we can see what the use case looks like.
>> 
>> That patch is getting sent soon. It's starting out in staging. Should I Cc you on that?
> 
> Why don't you wait until the driver is good enough for drivers/net proper?


It's code that I've manually stripped down as a subset of a larger code base for Freescale's DPAA driver. I've only tested it on our (Servergy's) platform, so until it gets more broad testing (and some code review), I want to at least get it into staging so our hardware is supported.

--
Servergy  : http://www.servergy.com/
SwissDisk : http://www.swissdisk.com/
Ubuntu    : http://www.ubuntu.com/
My Blog   : http://ben-collins.blogspot.com/

