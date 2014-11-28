Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaK1Pky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:40:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbaK1Pkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:40:51 -0500
Message-ID: <54789781.7060009@suse.cz>
Date: Fri, 28 Nov 2014 16:40:49 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] kbuild: Automatically remove stale <linux/version.h>
 file
References: <1417102689-19040-1-git-send-email-mmarek@suse.cz>
In-Reply-To: <1417102689-19040-1-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-27 16:38, Michal Marek wrote:
> In 3.7, the file moved from include/linux/ to
> include/generated/uapi/linux/. The path in the #include directive
> remained the same for compatibility reasons, but this created a problem
> when bisecting. Commit 9c8cdb71 (kbuild: unconditionally clobber
> include/linux/version.h on distclean) fixes this, provided the user does
> make distclean between builds. Better not rely on the user and delete
> the stale file each time make is invoked.

I added this to kbuild.git#kbuild.

Michal

