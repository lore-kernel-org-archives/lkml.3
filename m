Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab3GCMbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:31:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab3GCMbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:31:52 -0400
Message-ID: <51D419B2.7000502@suse.cz>
Date: Wed, 03 Jul 2013 14:31:46 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Daniel Tang <dt.tangr@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH 2/2] Fix a build warning in scripts/mod/file2alias.c
References: <1370745235-12951-1-git-send-email-dt.tangr@gmail.com> <1370745235-12951-2-git-send-email-dt.tangr@gmail.com>
In-Reply-To: <1370745235-12951-2-git-send-email-dt.tangr@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9.6.2013 04:33, Daniel Tang wrote:
> On some systems, __used is already defined in sys/cdefs.h and causes
> a build warning:
> 
> scripts/mod/file2alias.c:85:1: warning: "__used" redefined
> In file included from /usr/include/stdio.h:64,
>                  from scripts/mod/modpost.h:1,
> 		                  from scripts/mod/file2alias.c:13:
> 				  /usr/include/sys/cdefs.h:146:1: warning: this is the location of the previous definition
> 
> This adds an extra check before defining the __used macro to see if
> the macro was already defined elsewhere.
> 
> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>

Applied to kbuild.git#kbuild.

Michal

