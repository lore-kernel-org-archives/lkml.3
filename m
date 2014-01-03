Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaACNtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:49:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbaACNtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:49:45 -0500
Date: Fri, 3 Jan 2014 14:49:44 +0100
From: Michal Marek <mmarek@suse.cz>
To: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix detectition of kernel git repository in
 setlocalversion script [take #2]
Message-ID: <20140103134943.GB1676@sepie.suse.cz>
References: <529CA5DE.7030505@gmail.com>
 <1385998469-21515-1-git-send-email-fbuihuu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385998469-21515-1-git-send-email-fbuihuu@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 04:34:29PM +0100, Franck Bui-Huu wrote:
> setlocalversion script was testing the presence of .git directory in order to find out
> if git is used as SCM to track the current kernel project. However in some cases, .git
> is not a directory but can be a file: when the kernel is a git submodule part of a git
> super project for example.
> 
> This patch just fixes this by using 'git rev-parse --show-cdup' to check that the
> current directory is the kernel git topdir. This has the advantage to not test and rely
> on git internal infrastructure directly.
> 
> Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
> ---
>  scripts/setlocalversion | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Applied to kbuild.git#kbuild.

Michal
