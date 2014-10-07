Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaJGI5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 04:57:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42382 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbaJGI45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 04:56:57 -0400
Message-ID: <5433AAD5.8080108@suse.cz>
Date: Tue, 07 Oct 2014 10:56:53 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] deb-pkg: remove obsolete -isp option to dpkg-gencontrol
References: <1412530998-31193-1-git-send-email-asbjorn@asbjorn.biz>
In-Reply-To: <1412530998-31193-1-git-send-email-asbjorn@asbjorn.biz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-05 19:43, Asbjoern Sloth Toennesen wrote:
> The -isp option has been deprecated, after it became the default
> behaviour back in 2006.
> 
> Since dpkg 1.17.11, dpkg-gencontrol emits a warning on -isp usage.
> 
> References: https://bugs.debian.org/215233
> Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>

Applied to kbuild.git#misc, thanks.

Michal

