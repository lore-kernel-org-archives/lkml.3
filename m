Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaDWQYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:24:33 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:47783 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaDWQYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:24:32 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20140423181442.d4d07316c04a9a528a393ea1@skynet.be>
References: <20140423181442.d4d07316c04a9a528a393ea1@skynet.be>
Date: Wed, 23 Apr 2014 18:24:31 +0200
Message-ID: <CAJfpegtze0nd-Mho0Msc8YPmEOQ=8soN+aAyheEbkKYoR-m5LA@mail.gmail.com>
Subject: Re: [PATCH 1/1] FS/FUSE: add __exit to fuse_ctl_cleanup
From: Miklos Szeredi <miklos@szeredi.hu>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>,
        fuse-devel <fuse-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 6:14 PM, Fabian Frederick <fabf@skynet.be> wrote:
> fuse_ctl_cleanup is only called by __exit fuse_exit

Thanks, queued.

Miklos
