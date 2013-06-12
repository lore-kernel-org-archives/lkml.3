Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3FLPXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 11:23:50 -0400
Received: from www.xora.org.uk ([80.68.91.202]:37292 "EHLO
	xora.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3FLPXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 11:23:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Jun 2013 16:23:47 +0100
From: gg@slimlogic.co.uk
To: Mark Brown <broonie@kernel.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, lgirdwood@gmail.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [RFC PATCH] regulator: palmas: enable all modes for SMPS10
In-Reply-To: <20130612145126.GG1403@sirena.org.uk>
References: <20130604093816.GY31367@sirena.org.uk> <51ADB6BF.6020205@ti.com>
 <20130604100511.GA31367@sirena.org.uk> <51B5A14E.6000500@ti.com>
 <20130610100330.GO31367@sirena.org.uk> <51B5B268.8090908@ti.com>
 <20130610124924.GU31367@sirena.org.uk> <51B8345F.601@nvidia.com>
 <20130612141409.GE1403@sirena.org.uk>
 <bcb26ab704763c7ae7ef815b8fa0f652@slimlogic.co.uk>
 <20130612145126.GG1403@sirena.org.uk>
Message-ID: <feb8849eb7c84a17fd53da28df0f82e7@slimlogic.co.uk>
User-Agent: Roundcube Webmail/0.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-06-12 15:51, Mark Brown wrote:
> On Wed, Jun 12, 2013 at 03:31:09PM +0100, gg@slimlogic.co.uk wrote:
>> On 2013-06-12 15:14, Mark Brown wrote:
> 
>> >Yes, that seems like the most obvious thing here as far as I can tell
>> >from the frankly fragmented and obscure information but given all the
>> >confusion that seems to exist among the people working on the driver
>> >it's really not clear if there's something else going on.
> 
>> What about the case where they are inputs? For bus power?
> 
> So the current flow can change direction here?

Just rechecked the data sheet and it looks like that use-case has 
actually been
removed from more recent data sheets.

So ignore me, yes now it can be modelled by two regulators!

Graeme

