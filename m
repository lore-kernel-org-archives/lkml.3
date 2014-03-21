Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbaCUPWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:22:30 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:41831 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbaCUPW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:22:28 -0400
Message-ID: <532C5930.7040107@bjorling.me>
Date: Fri, 21 Mar 2014 08:22:24 -0700
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>, snitzer@redhat.com,
        agk@redhat.com, neilb@suse.de, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH RFC v1 00/01] dm-lightnvm introduction
References: <1395383538-18019-1-git-send-email-m@bjorling.me> <20140321090630.GA30044@debian>
In-Reply-To: <20140321090630.GA30044@debian>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 02:06 AM, Joe Thornber wrote:
> Hi Matias,
> 
> This looks really interesting and I'd love to get involved.  Do you
> have any recommendations for what hardware I should pick up?

Hi Joe,

The most easily available platform is OpenSSD
(http://www.openssd-project.org). It's a little old, but still very
functional. When there's a good firmware implementation, I think it will
be easier for the custom SSD vendor's to jump on board with their own
firmware.

- Matias

> 
> - Joe
> 
> 
> On Thu, Mar 20, 2014 at 11:32:17PM -0700, Matias Bjørling wrote:
>> Hi,
>>
>> Users that have custom firmware SSDs, may choose to expose their flash directly.
>> This allows the host to control logical to physical address mappings, garbage
>> collection strategy, wear-leveling, and so on.

