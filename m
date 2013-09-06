Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750776Ab3IFF4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 01:56:36 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9984 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3IFF4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 01:56:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 05 Sep 2013 22:56:32 -0700
Message-ID: <52297306.8000101@nvidia.com>
Date: Fri, 6 Sep 2013 11:45:34 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Lee Jones <lee.jones@linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "kishon@ti.com" <kishon@ti.com>, "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>
Subject: Re: [PATCH V4] regulator: palmas: add support for external control
 of rails
References: <1377082096-22296-1-git-send-email-ldewangan@nvidia.com> <20130823095841.GG25263@sirena.org.uk> <522897FD.2030509@nvidia.com> <20130905143431.GI8980@lee--X1> <52289BD4.9060607@nvidia.com> <20130905153432.GD3084@sirena.org.uk>
In-Reply-To: <20130905153432.GD3084@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 September 2013 09:04 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Thu, Sep 05, 2013 at 08:27:24PM +0530, Laxman Dewangan wrote:
>> On Thursday 05 September 2013 08:04 PM, Lee Jones wrote:
>>> It won't go in until v3.12 now, but I have applied the patch.
>> Thanks Lee for taking care.
> If it's going to wait for v3.12 there's no point applying it to MFD as
> the dependency will be in mainline after the merge window.
Agree that it should go on regulator tree if it is v3.12 and if there is 
any issue on applying the patch, I will resend at that time after 
rebasing to that branch.

Thanks,
Laxman

