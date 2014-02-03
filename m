Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaBCN1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 08:27:30 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:56117 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaBCN13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 08:27:29 -0500
X-IronPort-AV: E=Sophos;i="4.95,772,1384300800"; 
   d="scan'208";a="97269764"
Message-ID: <52EF993D.1000701@citrix.com>
Date: Mon, 3 Feb 2014 14:27:25 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: Julien Grall <julien.grall@linaro.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <jonathan.davies@citrix.com>, <wei.liu2@citrix.com>,
        <ian.campbell@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: [Xen-devel] [PATCH v6] xen/grant-table: Avoid m2p_override during
 mapping
References: <1390512224-27296-1-git-send-email-zoltan.kiss@citrix.com>	<alpine.DEB.2.02.1401232333280.15917@kaball.uk.xensource.com>	<52EE1E26.2040308@linaro.org> <52EE93F0.1020508@citrix.com> <52EF7618.7030402@citrix.com>
In-Reply-To: <52EF7618.7030402@citrix.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.14.37]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/14 11:57, David Vrabel wrote:
>>
>> Hi,
>>
>> That's bad indeed. I think the best solution is to put those parts
>> behind an #ifdef x86. The ones moved from x86/p2m.c to grant-table.c.
>> David, Stefano, what do you think?
> I don't think we want (more) #ifdef CONFIG_X86 in grant-table.c and the
> arch-specific bits will have to factored out into their own functions
> with suitable stubs provided for ARM.
>
I've just sent in v7 with stubs, I guess that's something you suggested. 
Please review it, I'm especially curious about your thoughts regarding 
the new function name.

Zoli
