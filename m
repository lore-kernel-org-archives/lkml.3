Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab3EPEXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 00:23:08 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23623 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab3EPEXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 00:23:04 -0400
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="47796564"
Message-ID: <51945F27.7010003@codeaurora.org>
Date: Wed, 15 May 2013 21:23:03 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Mike Turquette <mturquette@linaro.org>,
        =?ISO-8859-1?Q?Emilio_L=F3p?= =?ISO-8859-1?Q?ez?= 
	<emilio@elopez.com.ar>,
        =?ISO-8859-1?Q?S=F6ren_Bri?= =?ISO-8859-1?Q?nkmann?= 
	<soren.brinkmann@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
References: <1368207091-32538-1-git-send-email-soren.brinkmann@xilinx.com> <1368207091-32538-2-git-send-email-soren.brinkmann@xilinx.com> <518D320C.4010707@elopez.com.ar> <fe9e603e-a432-4a29-a195-fd393b875a7e@TX2EHSMHS006.ehs.local> <518D411D.9070209@elopez.com.ar> <CAPtuhTgsP4gvMAFoQb3icXAZw3ucSg4dfrAdJMho-VxNmNTvwg@mail.gmail.com> <518D7C45.2090602@codeaurora.org> <20130511142132.GA3200@sirena.org.uk>
In-Reply-To: <20130511142132.GA3200@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2013 07:21 AM, Mark Brown wrote:
> On Fri, May 10, 2013 at 04:01:25PM -0700, Saravana Kannan wrote:
>> On 05/10/2013 03:18 PM, Mike Turquette wrote:
>
> Guys please delete irrelevant context from replies...
>
>>> One way to do it is to introduce a new config option,
>>> CONFIG_COMMON_CLK_DEBUG_CONTROL that would expose the controls for
>>> every clock in the existing debugfs infrastructure.  The downside to
>>> this approach is that it would get abused and ship in millions of
>>> Android products using horrible userspace hacks to control clocks.
>>> Maybe that's not our problem to solve, maybe it is.
>
>> We already have this for MSM. But I seem to have managed to keep our
>> userspace guys away from abusing it. YMMV.
>
> It's much harder when it's in the standard kernel and there's no contact
> with some of the users.  I've pushed back pretty strongly on some of
> your equivalent stuff for regulators for this reason.

Agreed. I don't really keep up with what's going on with the MSM regulators.

But at some point, I'll start requesting for this for debugfs. It's 
terribly handy to debug power issues, run unit tests and for debug 
sessions (debugfs. So, clearly!).

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
