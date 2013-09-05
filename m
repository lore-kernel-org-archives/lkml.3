Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965030Ab3IEKC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:02:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35755 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935570Ab3IEKCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:02:55 -0400
Message-ID: <522856C9.3030106@suse.cz>
Date: Thu, 05 Sep 2013 12:02:49 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/3] kconfig: do not special-case 'MODULES' symbol
References: <1378242287-12759-1-git-send-email-yann.morin.1998@free.fr> <5228510C.1020906@suse.cz>
In-Reply-To: <5228510C.1020906@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5.9.2013 11:38, Michal Marek wrote:
> On 3.9.2013 23:04, Yann E. MORIN wrote:
>> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
>> This patch changes the way we enable/disable tristates: if a symbol was
>> found with 'option modules' attached to it, then that symbol controls
>> enabling tristates. Otherwise, tristates are disabled, even if a symbol
>> named 'MODULES' exists.
> 
> Wasn't this change supposed to fix allmodconfig with KCONFIG_ALLCONFIG
> (http://lkml.org/lkml/2013/8/8/573)? Or is there still more to do?
> Because I'm still getting:
> [...]
> $ grep MODULES .config
> CONFIG_MODULES_USE_ELF_RELA=y
> # CONFIG_MODULES is not set
> $

Otherwise, I have no problem merging this series. I'm just curious what
to do with the allmodconfig with KCONFIG_ALLCONFIG bug.

Michal
