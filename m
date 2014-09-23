Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbaIWSFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 14:05:43 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42401 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbaIWSFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 14:05:42 -0400
Date: Tue, 23 Sep 2014 19:05:39 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, kernel@stlinux.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Subject: Re: [STLinux Kernel] [PATCH 3/3] media: st-rc: Remove .owner field
 for driver
Message-ID: <20140923180539.GB3430@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1411424501-12673-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1411424568-12803-1-git-send-email-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411424568-12803-1-git-send-email-srinivas.kandagatla@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014, Srinivas Kandagatla wrote:

> There is no need to init .owner field.
> 
> Based on the patch from Peter Griffin <peter.griffin@linaro.org>
> "mmc: remove .owner field for drivers using module_platform_driver"
> 
> This patch removes the superflous .owner field for drivers which
> use the module_platform_driver API, as this is overriden in
> platform_driver_register anyway."
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Acked by: 
    Acked-by: Peter Griffin <peter.griffin@linaro.org>
