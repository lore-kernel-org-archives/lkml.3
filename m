Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab3LRPoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:44:39 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:33066 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3LRPoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:44:37 -0500
X-Auth-Info: VFGNe3JOY4umSPmAspLRGBkMwUGWNJPP7ZzRGrPp0q8=
From: Marek Vasut <marex@denx.de>
To: Luis Henriques <luis.henriques@canonical.com>
Subject: Re: [PATCH 3.5 057/103] HID: add quirk for Freescale i.MX23 ROM recovery
Date: Tue, 17 Dec 2013 20:39:03 +0100
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Jiri Kosina <jkosina@suse.cz>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com> <1387304012-23805-58-git-send-email-luis.henriques@canonical.com>
In-Reply-To: <1387304012-23805-58-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201312172039.03504.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 17, 2013 at 07:12:46 PM, Luis Henriques wrote:
> 3.5.7.28 -stable review patch.  If anyone has any objections, please let me
> know.

Hi,

while I cannot test this anymore as I don't have these machines with ubuntu 
12.04.3 available anymore (I won't do a distro war, don't worry :) ), I have two 
simple questions:

a) Will you be able to pick the other two patches from [1] ?
b) Will these patches make it into ubuntu 12.03.n ?

I will have these machines available in january again, so I will be able to 
test.

Thank you!

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1258332

Best regards,
Marek Vasut
