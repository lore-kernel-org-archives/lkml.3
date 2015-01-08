Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbbAHOGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:06:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbbAHOGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:06:24 -0500
Message-ID: <54AE8EDE.8010608@suse.cz>
Date: Thu, 08 Jan 2015 15:06:22 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-kbuild@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: use mixed-targets when two or more config targets
 are given
References: <1418292754-2987-1-git-send-email-yamada.m@jp.panasonic.com>
In-Reply-To: <1418292754-2987-1-git-send-email-yamada.m@jp.panasonic.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-11 11:12, Masahiro Yamada wrote:
> "make kvmconfig" expects that the .config has already been created,
> but some people might want to create the .config and run kvmconfig
> in one shot command, like this:
> 
>   $ make defconfig kvmconfig
> 
> To make sure this command works correctly even if -j* option is set,
> we must handle them one by one.
> This commit turns on mixed-targets when $(MAKECMDGOALS) includes
> at least one config target and also includes another target.
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>

Applied to kbuild.git#kbuild, thanks.

Michal

