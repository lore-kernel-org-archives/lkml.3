Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab3GWIUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:20:40 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:36554 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab3GWIUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:20:37 -0400
Message-ID: <51EE3BFA.5000403@linux.vnet.ibm.com>
Date: Tue, 23 Jul 2013 13:46:58 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Kiko Piris <kernel@pirispons.net>, Paul Bolle <pebolle@tiscali.nl>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: 3.10.1 cpufreq suspend/resume regression still present in 3.10.2
References: <20130722151653.GA7213@sacarino.pirispons.net> <1374507247.15242.26.camel@x61.thuisdomein> <20130722155456.GA7836@sacarino.pirispons.net> <51ED56FF.9030508@linux.vnet.ibm.com> <20130722205203.GA8075@sacarino.pirispons.net>
In-Reply-To: <20130722205203.GA8075@sacarino.pirispons.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072308-8256-0000-0000-000008768DCB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 02:22 AM, Kiko Piris wrote:
> On 22/07/2013 at 21:29 +0530, Srivatsa S. Bhat wrote:
> 
>> Try applying the two mainline commits that I mentioned in my previous
>> mail, on top of 3.10.2 and check if it fixes your problem.
> 
> It does fix it.
> 
> Running 3.10.2 with your two patches, suspended and resumed a couple of
> times without a problem (previously it didn’t wake up 100% of the
> times).
> 
> Thank you both for your help!
> 

Thank you for your testing efforts and for confirming that the
patches fix your issue.

 
Regards,
Srivatsa S. Bhat

