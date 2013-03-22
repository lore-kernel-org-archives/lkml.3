Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540Ab3CVOdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:33:39 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:53202 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625Ab3CVOdh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:33:37 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] phy: Add XGMII phy interface type
From: Ben Collins <benmcollins13@gmail.com>
In-Reply-To: <20130322.102738.100763719710671227.davem@davemloft.net>
Date: Fri, 22 Mar 2013 10:33:39 -0400
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <3B6C8A6E-72C7-450E-BC89-818E87E58349@gmail.com>
References: <5BDCE647-67A3-423B-AB9C-8C50CC0B6C02@gmail.com> <20130322.101900.1947638393872492900.davem@davemloft.net> <9CC1FA76-1620-4E0F-82DC-89535633329F@gmail.com> <20130322.102738.100763719710671227.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 22, 2013, at 10:27 AM, David Miller <davem@davemloft.net> wrote:

> From: Ben Collins <benmcollins13@gmail.com>
> Date: Fri, 22 Mar 2013 10:22:05 -0400
> 
>> It's code that I've manually stripped down as a subset of a larger
>> code base for Freescale's DPAA driver. I've only tested it on our
>> (Servergy's) platform, so until it gets more broad testing (and some
>> code review), I want to at least get it into staging so our hardware
>> is supported.
> 
> Then why don't you submit the PHY type addition with the staging
> driver, which will be the only user, and you can add my:
> 
> Acked-by: David S. Miller <davem@davemloft.net>


That I can do. Greg had asked I get all the rest of this signed off before he could take the driver into staging.

--
Servergy  : http://www.servergy.com/
SwissDisk : http://www.swissdisk.com/
Ubuntu    : http://www.ubuntu.com/
My Blog   : http://ben-collins.blogspot.com/

