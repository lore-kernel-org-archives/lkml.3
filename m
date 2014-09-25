Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaIYL3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 07:29:00 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:35192 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbaIYL26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 07:28:58 -0400
Message-ID: <1411644540.18580.128.camel@iivanov-dev>
Subject: Re: [PATCH] USB: Remove .owner field for driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Thu, 25 Sep 2014 14:29:00 +0300
In-Reply-To: <1411557494-32535-1-git-send-email-kiran.padwal@smartplayin.com>
References: <1411557494-32535-1-git-send-email-kiran.padwal@smartplayin.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-24 at 16:48 +0530, Kiran Padwal wrote:
> There is no need to init .owner field.
> 
> Based on the patch from Peter Griffin <peter.griffin@linaro.org>
> "mmc: remove .owner field for drivers using module_platform_driver"
> 
> This patch removes the superflous .owner field for drivers which
> use the module_platform_driver API, as this is overriden in
> platform_driver_register anyway."
> 
> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>

Thank you Kiran.

Reviewed-by: Ivan T. Ivanov <iivanov@mm-sol.com>


