Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143AbaEEOws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:52:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933128AbaEEOwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:52:46 -0400
Message-ID: <5367A5BD.2010904@suse.cz>
Date: Mon, 05 May 2014 16:52:45 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] kbuild: Use relative paths if possible
References: <1398780493-15391-1-git-send-email-mmarek@suse.cz> <20140430161358.GB15320@ravnborg.org>
In-Reply-To: <20140430161358.GB15320@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-30 18:13, Sam Ravnborg wrote:
> On Tue, Apr 29, 2014 at 04:08:08PM +0200, Michal Marek wrote:
>> Hi,
>>
>> This series changes the Makefile to use relative paths for $(objtree),
>> always setting it to '.', and for $(srctree) setting either to '.' or
>> '..', when building in the source tree or a subdirectory thereof,
>> respectively. The goal is to make compiler messages and Ooopses more
>> readable by avoiding the full path to the source/object directory.
>>
>> Patch 2/5 is just an unrelated cleanup.
>>
>> Michal
>>
>> Michal Marek (5):
>>   firmware: Simplify directory creation
>>   firmware: Use $(quote) in the Makefile
>>   kbuild: Use relative path for $(objtree)
>>   kbuild: Use relative path when building in the source tree
>>   kbuild: Use relative path when building in a subdir of the source tree
> 
> For patch 2,3,4 and 5 you can add my:
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

Thanks!

Michal
