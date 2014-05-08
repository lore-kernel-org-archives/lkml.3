Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaEHLs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 07:48:26 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:41961 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbaEHLsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 07:48:25 -0400
Message-ID: <1399549654.8165.1.camel@iivanov-dev>
Subject: Re: [PATCH 3/4] of/platform: fix device naming for non-translatable
 addresses
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn@kryo.se>, Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh@kernel.org>
Date: Thu, 08 May 2014 14:47:34 +0300
In-Reply-To: <1399499298-8830-4-git-send-email-robherring2@gmail.com>
References: <1399499298-8830-1-git-send-email-robherring2@gmail.com>
	 <1399499298-8830-4-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-07 at 16:48 -0500, Rob Herring wrote:
> From: Rob Herring <robh@kernel.org>
> 
> Using non-translatable addresses in platform device names is wrong
> because they may not be globally unique. Just use the default naming with
> a global index if the address cannot be translated instead.
> 
> of_can_translate_address has the same checks as of_translate_address, so
> we can remove it here as well.
> 
> Reported-by: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> Cc: Josh Cartwright <joshc@codeaurora.org>
> Cc: Courtney Cavin <courtney.cavin@sonymobile.com>
> Cc: Bjorn Andersson <bjorn@kryo.se>
> Cc: Frank Rowand <frowand.list@gmail.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Signed-off-by: Rob Herring <robh@kernel.org>

Thanks. It works for me. 

Tested-by: Ivan T. Ivanov <iivanov@mm-sol.com>

Regards.

