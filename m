Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab3AWFFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 00:05:10 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:47823 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3AWFFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 00:05:08 -0500
MIME-Version: 1.0
Date: Wed, 23 Jan 2013 10:35:07 +0530
Message-ID: <CAJ8eaTxhYqen0g2a2Gjhw-UxD9wnDB1kHPHub-3BKSqAM7MLYw@mail.gmail.com>
Subject: Boot ARM (Cortex A-9) target without device tree support
From: naveen yadav <yad.naveen@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

We want to run our embedded target on 3.8-rc4 without using device
tree support. Is it possible.
If yes then is it controlled by .config or I need to revert some patches.

Thanks
