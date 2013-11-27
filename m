Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab3K0BPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:15:48 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:54418 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759348Ab3K0BPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:15:22 -0500
MIME-Version: 1.0
In-Reply-To: <20131126130014.GH7427@katana>
References: <1385409678-4398-1-git-send-email-tim.kryger@linaro.org>
	<20131126130014.GH7427@katana>
Date: Tue, 26 Nov 2013 17:15:22 -0800
Message-ID: <CAAYSxhoJwg1VsPdfs4XWxq1pBmAyACbG4SgOUHyKyNAB_EzVQA@mail.gmail.com>
Subject: Re: [PATCH] i2c: i2c-bcm-kona: Fix module build
From: Tim Kryger <tim.kryger@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 5:00 AM, Wolfram Sang <wsa@the-dreams.de> wrote:

> Have you also tried repeated module loading/unloading?

I ran a loop of insmod + rmmod 1000 times and didn't see any issues.

Thanks,
Tim Kryger
