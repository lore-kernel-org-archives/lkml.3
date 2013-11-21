Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab3KUSo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 13:44:28 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46223 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab3KUSo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 13:44:26 -0500
Message-ID: <528E5487.8000003@wwwdotorg.org>
Date: Thu, 21 Nov 2013 11:44:23 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, ldewangan@nvidia.com, lgirdwood@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: commit c368e5fc2a190923b786f2de3e79430ea3566a25 regresses MMC
References: <20131120175814.GC27423@saruman.home> <20131120203400.GL2674@sirena.org.uk> <20131120205143.GA9182@saruman.home> <20131121024840.GA22970@saruman.home> <20131121104911.GM2674@sirena.org.uk> <528E3817.1010105@wwwdotorg.org> <20131121183632.GE8120@sirena.org.uk>
In-Reply-To: <20131121183632.GE8120@sirena.org.uk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 11:36 AM, Mark Brown wrote:
> On Thu, Nov 21, 2013 at 09:43:03AM -0700, Stephen Warren wrote:
> 
>> FYI, the way I deal with this is that my preferred email account 
>> subscribes to the mailing list, and I have a filter such that
>> anything that's to/cc either *that* email address *or* any of my
>> other email addresses gets handled the same, and dumped in my
>> (list) inbox rather than in a mailing list folder.
> 
> I used to do that but I found it tended to create annoying
> duplicates more often than it was helpful.  It's also a bit of an
> issue for me that there are other people with the same name who
> work upstream so I do also find people from time to time picking
> the wrong Mark Brown to e-mail.

Ah yes. I also have a delivery-time filter that remembers the last n
Message-Id headers I've received, and it dumps any duplicates into a
separate folder that I ignore. It seems to work pretty well. It looks
like n==10000 for me right now.

I could post the scripts on github if people think they're useful.
Hopefully there aren't security bugs:-)
