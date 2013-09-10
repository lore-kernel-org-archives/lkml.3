Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3IJIZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:25:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54236 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362Ab3IJIZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:25:06 -0400
Message-ID: <522ED75B.4070809@ti.com>
Date: Tue, 10 Sep 2013 13:54:59 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: <linux-kernel@vger.kernel.org>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>, <ldewangan@nvidia.com>
Subject: Re: [PATCH] extcon: palmas: Dont set USB state if ID pin is grounded
References: <1378799369-15803-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1378799369-15803-1-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 10 September 2013 01:19 PM, George Cherian wrote:
> In OMAP5 when USB-HOST is set true, the VBUS regulator  is turned ON.
> This causes a VBUS interrupt, ignore the same if we are already in
> USB-HOST.

You'll get VBUS interrupt when detaching USB-HOST cable also no? (because you
do a regulator disable to SMPS10).

Thanks
Kishon
