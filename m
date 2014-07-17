Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbaGQJqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:46:53 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:49231 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbaGQJqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:46:49 -0400
Message-ID: <53C79B85.20805@plexistor.com>
Date: Thu, 17 Jul 2014 12:46:45 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, David Howells <dhowells@redhat.com>
CC: sam@ravnborg.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Fix compiler message generation
References: <20140702105645.17220.92338.stgit@warthog.procyon.org.uk> <20140702124016.GA26965@sepie.suse.cz> <53C6A509.5060809@plexistor.com> <53C792D3.20705@suse.cz>
In-Reply-To: <53C792D3.20705@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 12:09 PM, Michal Marek wrote:
> On 2014-07-16 18:15, Boaz Harrosh wrote:
>> This patch by itself works with kdevelop so I hope you did not submit my crap
>> KBUILD_FULL_PATH patch at all and only added this one (and I know, the fix to this
>> one with the -s)
> 
> Yes, I did not merge the KBUILD_FULL_PATH patch, because the approach
> with the make message works out of the box.
> 
> 
>> Also not that I like your patches because now I can compile the same directory
>> from different machines with different absolute paths to the source and the
>> compilation will come out the same. (before changed absolute path would cause
>> a rebuild)
> 

Rrrr I hope you understood that not => Note above. I *do* like your patch a lot

> That's a nice side effect which I did not realize initially ;).
> 

I guess this is everywhere that has __FILE__ in code needs to be rebuilt
So it is more in debug builds than ndebug.

> Michal
> 

Ye cool thanks, all is well
Boaz

