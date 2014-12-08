Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbaLHMO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 07:14:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203AbaLHMO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 07:14:28 -0500
Message-ID: <54859620.7030304@suse.cz>
Date: Mon, 08 Dec 2014 13:14:24 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: j.glisse@gmail.com, linux-kernel@vger.kernel.org
CC: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>
Subject: Re: [PATCH] scripts/package: binrpm-pkg do not build source tar file
 v4
References: <1417708393-14318-1-git-send-email-j.glisse@gmail.com>
In-Reply-To: <1417708393-14318-1-git-send-email-j.glisse@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 4.12.2014 v 16:53 j.glisse@gmail.com napsal(a):
> From: Jérôme Glisse <jglisse@redhat.com>
> 
> When doing make binrpm-pkg we only want to build the binary and header
> package as the documentation of binrpm-pkg target claims. Hence this
> patch avoid building the source and devel package. This makes binrpm-pkg
> target lot faster and way more usefull.
> 
> Changed since v3 :
>   - Avoid creating /usr/src/kernels directory.
>   - Avoid useless pre clean step of source and devel package.
> 
> Changed since v2 :
>   - Avoid symlinks in /usr/src/kernel.
>   - Update subject line and changelog.
> 
> Changed since v1 :
>   - Avoid building the devel package too.
> 
> Signed-off-by: Jérôme Glisse <jglisse@redhat.com>

Thanks, applied to kbuild.git#misc. I just used the subject line from
v3, since it seems you accidentally reverted to that from v2.

Michal

