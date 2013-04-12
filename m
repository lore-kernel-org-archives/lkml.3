Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab3DLHkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 03:40:41 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:41336 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab3DLHkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 03:40:39 -0400
Message-ID: <5167BA67.5080403@synopsys.com>
Date: Fri, 12 Apr 2013 13:10:23 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kbuild@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Kbuild: Avoid DTB rebuilds if source files are untouched
References: <1364973141-16354-1-git-send-email-vgupta@synopsys.com> <515BD6B8.1020607@synopsys.com> <515C5652.8070705@wwwdotorg.org> <515D0FFB.4030803@synopsys.com> <515DBA0E.6000604@wwwdotorg.org> <51642158.3070205@synopsys.com>
In-Reply-To: <51642158.3070205@synopsys.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 07:40 PM, Vineet Gupta wrote:
> On 04/04/2013 11:06 PM, Stephen Warren wrote:
>
>> +.SECONDARY: $(obj)/%.dtb.S
>> +
>>  $(obj)/%.dtb.S: $(obj)/%.dtb
>>         $(call cmd,dt_S_dtb)
>>
>> and no longer see make rm'ing the .dtb.S file. So, the .SECONDARY is
>> behaving as expected, and should fix your problem.
> Interestingly, if I make the file name explicit, .SECONDARY works for me too.
>
> .SECONDARY: $(obj)/angel4.dtb.S
>
> http://stackoverflow.com/questions/5426934/why-this-makefile-removes-my-goal
>
> Is this a make bug or is it related to when the rule is parsed by make !
>
> -Vineet

Ping ? Anyone know how to resolve this

-Vineet


