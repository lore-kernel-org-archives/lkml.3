Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab3CUReA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 13:34:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52555 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab3CURd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 13:33:59 -0400
Message-ID: <514B4484.3030304@wwwdotorg.org>
Date: Thu, 21 Mar 2013 11:33:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, Axel Lin <axel.lin@ingics.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BUG: pinmux: forbid mux_usecount to be set at UINT_MAX
References: <5149ED25.4010309@wwwdotorg.org> <1363864907-28351-1-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1363864907-28351-1-git-send-email-richard.genoud@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 05:21 AM, Richard Genoud wrote:
> If pin_free is called on a pin already freed, mux_usecount is set to
> UINT_MAX which is really a bad idea.
> This will issue a warning, so that we can correct the code responsible
> for the double free.
> 
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
> Ok Stephen, your idea (and code) seems better.
> I signed-off it, but it's really yours...
> Feel free to transform my Signed-off-by in a Tested-by

In this situation, I think you'd often say:
Suggested-by: Stephen Warren <swarren@nvidia.com>

FWIW,
Reviewed-by: Stephen Warren <swarren@nvidia.com>
