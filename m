Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab3H3I7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 04:59:17 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:45697 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3H3I7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 04:59:15 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <1377819852.2355.28.camel@perseus.fritz.box>
References: <1375975490-18673-1-git-send-email-miklos@szeredi.hu>
	<20130821054055.GN27005@ZenIV.linux.org.uk>
	<1377748272.9297.47.camel@tucsk.piliscsaba.szeredi.hu>
	<1377818677.2355.25.camel@perseus.fritz.box>
	<1377819852.2355.28.camel@perseus.fritz.box>
Date: Fri, 30 Aug 2013 10:59:11 +0200
Message-ID: <CAJfpegv18PCygsnpYXNLv6mD+Lff9dbVwtoV4OCbzjftc8HVAA@mail.gmail.com>
Subject: Re: [PATCH 0/9] [RFC v2] safely drop directory dentry on failed revalidate
From: Miklos Szeredi <miklos@szeredi.hu>
To: Ian Kent <raven@themaw.net>
Cc: Miklos Szeredi <mszeredi@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Ric Wheeler <rwheeler@redhat.com>, Anand Avati <avati@redhat.com>,
        Brian Foster <bfoster@redhat.com>, David Howells <dhowells@redhat.com>,
        Eric Paris <eparis@redhat.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 1:44 AM, Ian Kent <raven@themaw.net> wrote:

>> The check in waitq.c above "is" used to validate the need to callback to
>> the daemon to request a mount.

Okay.  But then shouldn't the check be  "if (d_mountpoint(dentry)) valid = 0;" ?

Thanks,
Miklos
