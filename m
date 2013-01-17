Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab3AQKyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:54:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60309 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab3AQKyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:54:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [RFC Patch v1 52/55] ARC: Support for single cycle Close Coupled Mem (CCM)
Date: Thu, 17 Jan 2013 10:53:57 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com> <201211121410.02682.arnd@arndb.de> <50F7878C.4020800@synopsys.com>
In-Reply-To: <50F7878C.4020800@synopsys.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301171053.58210.arnd@arndb.de>
X-Provags-ID: V02:K0:Tp+DdcInspeL6JCHU+PFQLCPNh4iIFaL+yeghbNrUte
 ggSEQYOpHD+/gPghBQp998/WEWZ4HY2Opz7cysumJjMC38EhdN
 Vv8YQJWPZlIP/JXEuaoRBvE3ljNFGon6JodCWxvEBhc93Qql59
 CJ1vUa6PBJa/OFrPcXmlg+algbfcKdTckRAkTVH7uyhKunEbr4
 1VFRXM5vfwZ8Yj5BMSUdoz+OpZ/4xjBV8SauXJ9s9rwWbfT/Of
 GwSMKfxSAa7piIj4BYycJImkha+FLqp8iKmmT54oUcYTOeQEk8
 cYcBVO3taXyyX3+WrwETCa0j4BViv7xAsbF+9GFUs5WPoEd9ik
 mSGsqNK/NtwGX+WLNlUg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2013, Vineet Gupta wrote:
> Actually in ARC Port these are used in Linker script to layout the kernel
> code/data at the addr where these hardware blocks are wired up. So can't be done
> at runtime.

Ok, makes sense.

	Arnd
