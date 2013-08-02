Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3HBPYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 11:24:53 -0400
Received: from smtp131.dfw.emailsrvr.com ([67.192.241.131]:60694 "EHLO
	smtp131.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab3HBPYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 11:24:51 -0400
Message-ID: <51FBCF05.9090509@calxeda.com>
Date: Fri, 02 Aug 2013 10:23:49 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/5] sata, highbank: fix ordering of SGPIO signals
References: <1374851518-4802-1-git-send-email-mark.langsdorf@calxeda.com> <20130729165530.GG22605@mtj.dyndns.org>
In-Reply-To: <20130729165530.GG22605@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 11:55 AM, Tejun Heo wrote:
> On Fri, Jul 26, 2013 at 10:11:54AM -0500, Mark Langsdorf wrote:
>> The ACTIVITY and ERROR signals were reversed in the original commit.
>> Fix that.
> 
> And what's the implication of this change?  Does this change the
> behavior of the driver?  If so, how?  If not, why not?  *Please* be
> more descriptive in patch descriptions and explain *why* the changes
> are being made.

I didn't think I needed more of an explanation than "this is completely
wrong per the spec" but I'll revise and resubmit.

--Mark Langsdorf
Calxeda, Inc.

