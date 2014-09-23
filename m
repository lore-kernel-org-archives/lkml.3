Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbaIWQHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:07:38 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:47791 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaIWQHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:07:37 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
References: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
Date: Tue, 23 Sep 2014 18:07:35 +0200
Message-ID: <CAJfpegv4RJzWV7=oHvyUWqUnJYk8JHrQsiKfJ5AMRFRaN3frxw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] fuse: Add support for mounts from pid/user namespaces
From: Miklos Szeredi <miklos@szeredi.hu>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 5:44 PM, Seth Forshee <seth.forshee@canonical.com> wrote:
> Here's an updated set of patches for allowing fuse mounts from pid and
> user namespaces. I discussed some of the issues we debated with the last
> patch set (and a few others) with Eric at LinuxCon, and the updates here
> mainly reflect the outcome of those discussions.
>
> The stickiest issue in the v1 patches was the question of where to get
> the user and pid namespaces from that are used for translating ids for
> communication with userspace. Eric told me that for user namespaces at
> least we need to grab a namespace at open or mount time and use only
> that namespace to prevent certain types of attacks.

I'm not convinced.  Let us have the gory details, please.

Thanks,
Miklos
