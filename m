Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab3FRM4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:56:24 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:57015 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3FRM4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 08:56:23 -0400
Message-ID: <51C058F5.80609@cogentembedded.com>
Date: Tue, 18 Jun 2013 16:56:21 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tushar Behera <tushar.behera@linaro.org>,
        Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the usb tree
References: <20130618161239.5ce92432180d9418831d2514@canb.auug.org.au>
In-Reply-To: <20130618161239.5ce92432180d9418831d2514@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 18-06-2013 10:12, Stephen Rothwell wrote:

> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/usb/phy/phy-rcar-usb.c between commit 56a9a6de2a87 ("usb: phy:
> rcar-usb: Fix comment w.r.t. devm_ioremap_resource") from the usb tree
> and commit 725bf9dcafe1 ("phy-rcar-usb: correct base address") from the
> arm-soc tree.

    Darn, and I forewarned not to apply the former commit.

WBR, Sergei

