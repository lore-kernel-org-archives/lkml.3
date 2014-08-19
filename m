Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaHSQO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 12:14:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36217 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaHSQO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 12:14:26 -0400
Message-ID: <53F377F5.4080304@wwwdotorg.org>
Date: Tue, 19 Aug 2014 10:14:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Thierry Reding <treding@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: Re: [PATCH] regmap: fix of_regmap_get_endian()
References: <1408400044-2560-1-git-send-email-swarren@wwwdotorg.org> <20140819153451.GB24407@sirena.org.uk>
In-Reply-To: <20140819153451.GB24407@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2014 09:34 AM, Mark Brown wrote:
> On Mon, Aug 18, 2014 at 04:14:04PM -0600, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Commit d647c199510c ("regmap: add DT endianness binding support") has
>> some issues. Specifically, if config->reg_format_endian is not explicitly
>> set, it will be zero, i.e. REGMAP_ENDIAN_DEFAULT. The switch statement
>
> Please respin this against current code, as Xiubo said Javier fixed some
> of this already.

Sure. For some reason, my email client's search for of_regmap_get_endian 
didn't find the message even though that word is part of it:-/
