Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbaIQBxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 21:53:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60408 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaIQBxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 21:53:44 -0400
Message-ID: <5418E9A2.3090304@wwwdotorg.org>
Date: Tue, 16 Sep 2014 19:53:38 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Lubomir Rintel <lkundrak@v3.sk>
CC: linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: bcm2835: Enable USB_DWC2_HOST in bcm2835_defconfig
References: <1410878435-12499-1-git-send-email-lkundrak@v3.sk>
In-Reply-To: <1410878435-12499-1-git-send-email-lkundrak@v3.sk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 08:40 AM, Lubomir Rintel wrote:
> It broke when host was moved into a separate module, in [47a1685f1].
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

I've forwarded this patch to armsoc to be applied.
