Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbaGQJ2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:28:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbaGQJ2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:28:18 -0400
Message-ID: <53C792D3.20705@suse.cz>
Date: Thu, 17 Jul 2014 11:09:39 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Boaz Harrosh <boaz@plexistor.com>, David Howells <dhowells@redhat.com>
CC: torvalds@linux-foundation.org, sam@ravnborg.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Fix compiler message generation
References: <20140702105645.17220.92338.stgit@warthog.procyon.org.uk> <20140702124016.GA26965@sepie.suse.cz> <53C6A509.5060809@plexistor.com>
In-Reply-To: <53C6A509.5060809@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-16 18:15, Boaz Harrosh wrote:
> This patch by itself works with kdevelop so I hope you did not submit my crap
> KBUILD_FULL_PATH patch at all and only added this one (and I know, the fix to this
> one with the -s)

Yes, I did not merge the KBUILD_FULL_PATH patch, because the approach
with the make message works out of the box.


> Also not that I like your patches because now I can compile the same directory
> from different machines with different absolute paths to the source and the
> compilation will come out the same. (before changed absolute path would cause
> a rebuild)

That's a nice side effect which I did not realize initially ;).

Michal
