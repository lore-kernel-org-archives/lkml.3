Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab3FLIik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:38:40 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10653 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab3FLIih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:38:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 12 Jun 2013 01:37:30 -0700
Message-ID: <51B8345F.601@nvidia.com>
Date: Wed, 12 Jun 2013 14:12:07 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "balbi@ti.com" <balbi@ti.com>
Subject: Re: [RFC PATCH] regulator: palmas: enable all modes for SMPS10
References: <20130601184511.GC16790@sirena.org.uk> <51AA456E.3030307@nvidia.com> <20130601210511.GT16790@sirena.org.uk> <51ADAE78.4050900@ti.com> <20130604093816.GY31367@sirena.org.uk> <51ADB6BF.6020205@ti.com> <20130604100511.GA31367@sirena.org.uk> <51B5A14E.6000500@ti.com> <20130610100330.GO31367@sirena.org.uk> <51B5B268.8090908@ti.com> <20130610124924.GU31367@sirena.org.uk>
In-Reply-To: <20130610124924.GU31367@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 June 2013 06:19 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Mon, Jun 10, 2013 at 04:33:04PM +0530, Kishon Vijay Abraham I wrote:
>> IIUC, normal enable should be when output is driven through OUT2.
> I'm sorry but you're really not making much sense at all here.  You say
> there are two different outputs here...
>
> Please think about what the hardware is doing and try to map it onto the
> APIs in a coherent fashion - pasting in large sections of dataseet isn't
> usually helpful, the goal is to map it onto abstractions.
>

I think ff we really want to abstract this stuff then we should have the 
two different regulator SMPS10-OUT1 and SMPS-OUT2 as there is physically 
two pins in the device for output and controlled different way.

