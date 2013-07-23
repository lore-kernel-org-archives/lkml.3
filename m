Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934056Ab3GWSJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:09:25 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:37944 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933943Ab3GWSJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:09:21 -0400
MIME-Version: 1.0
In-Reply-To: <1374602524-3398-12-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
	<1374602524-3398-12-git-send-email-wsa@the-dreams.de>
Date: Tue, 23 Jul 2013 15:09:20 -0300
Message-ID: <CAOMZO5DxOOaMudN8UY6gWmMqpHQ78e6++Soqi=VTB45_aNOZ1Q@mail.gmail.com>
Subject: Re: [PATCH 11/27] drivers/mtd/nand: don't check resource with devm_ioremap_resource
From: Fabio Estevam <festevam@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 3:01 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

I have already submitted such change:
http://patchwork.ozlabs.org/patch/260537/
