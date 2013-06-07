Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab3FGQYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:24:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48970 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab3FGQYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:24:06 -0400
Message-ID: <51B20922.4070504@wwwdotorg.org>
Date: Fri, 07 Jun 2013 10:24:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Olof Johansson <olof@lixom.net>, gnurou@gmail.com,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v3] simplefb: add support for a8b8g8r8 pixel format
References: <1370590290-13467-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1370590290-13467-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 01:31 AM, Alexandre Courbot wrote:
> A framebuffer of this format is set up by SHIELD's bootloader.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Acked-by: Olof Johansson <olof@lixom.net>

Reviewed-by: Stephen Warren <swarren@nvidia.com>
