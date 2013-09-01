Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab3IAANp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 20:13:45 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:32899 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab3IAANn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 20:13:43 -0400
Message-ID: <52228692.8060709@gmail.com>
Date: Sun, 01 Sep 2013 02:13:06 +0200
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:23.0) Gecko/20100101 Firefox/23.0 SeaMonkey/2.20
MIME-Version: 1.0
To: Dan Aloni <alonid@stratoscale.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Al Viro <viro@zeniv.linux.org.uk>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH linux-next] Prevent a coredump with a large vm_map_count
 from Oopsing
References: <20130830065707.GA31940@gmail.com> <1377930042-32442-1-git-send-email-alonid@stratoscale.com> <5221F1D9.9030001@gmail.com> <20130831135122.GA11096@gmail.com>
In-Reply-To: <20130831135122.GA11096@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Aloni wrote:
> On Sat, Aug 31, 2013 at 03:38:33PM +0200, Martin MOKREJŠ wrote:
>> Hi Dan,
>>   thank you for your work on my issue. I would like to test it on 3.10.9 where
>> I faced the problem initially.
> 
> Sure, see the attached patch for 3.10.9.

Thanks, it works for my case. You can add my Reported-by: and Tested-by:. ;-)
