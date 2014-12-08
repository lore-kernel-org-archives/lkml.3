Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbaLHNQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:16:08 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:50109 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387AbaLHNQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:16:06 -0500
Date: Mon, 8 Dec 2014 13:15:58 +0000
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, broonie@kernel.org, kernel@stlinux.com,
        linux-spi@vger.kernel.org
Subject: Re: [STLinux Kernel] [PATCH v3 4/4] ARM: sti: Provide DT nodes for
 SBC SSC[0..2]
Message-ID: <20141208131558.GA29220@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1418043214-14324-1-git-send-email-lee.jones@linaro.org>
 <1418043214-14324-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418043214-14324-5-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mon, 08 Dec 2014, Lee Jones wrote:

> The Synchronous Serial Controller is used to provide SPI.
> 
> These are the ports which are located on the Stand-By Controller (SBC).

After my series which adds stih410 SoC support, these nodes should now live in the
common stih407-family.dtsi file (common to both SoC's).

regards,

Peter.
