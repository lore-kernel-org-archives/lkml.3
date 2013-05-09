Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab3EIN3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 09:29:43 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:64740 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab3EIN3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 09:29:42 -0400
Message-ID: <518BA4BC.1090203@gmail.com>
Date: Thu, 09 May 2013 07:29:32 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Runzhen <icycoder@gmail.com>
CC: linux-kernel@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 10/13] perf kvm: add live mode
References: <1368073909-8825-1-git-send-email-dsahern@gmail.com> <1368073909-8825-11-git-send-email-dsahern@gmail.com> <518B9778.3080905@gmail.com>
In-Reply-To: <518B9778.3080905@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/13 6:32 AM, Runzhen wrote:
> Hi, David,
>
> Xiao Guangrong forward your patch to me two month ago, it is originally
> at https://github.com/dsahern/linux.git.
>
> However, those patches were based on an old linux tree, they can't be
> applied to current linux tree, so I try to fix the conflicts on the
> latest Arnaldo Carvalho de Melo tree, and I finished this work Yesterday!

I update the patches as kernel versions are released (not rc's though) 
and push to the github site. This round uses the consolidated open 
counters code that Arnaldo did back in December. I was distracted with 
other work and missed what he had done until recently. I need to address 
comments and resubmit. Should be able to get this into Arnaldo's tree 
soon and then into v3.11. The patches on github can be used for older 
versions.

>
> So, I'm sorry that I didn't inform you earlier, and we do the repetitive
> work.
>
> In your original patch, you hope the live mode can change display time
> dynamically. Fortunately, I implement this function and I will send the
> patch to you as soon as possible, please wait. :)

Awesome, look forward to seeing it.

David
