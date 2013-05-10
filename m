Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3EJONd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:13:33 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:39726 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab3EJONc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:13:32 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
Date: Fri, 10 May 2013 16:13:30 +0200
Message-ID: <CAJfpegtADAJ+7-DiFvrgWU1N5Fsd_CCQryT0mpx6VOJ=8ikKsA@mail.gmail.com>
Subject: Mount failure due to restricted access to a point along the mount path
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-cifs@vger.kernel.org
Cc: Steve French <smfrench@gmail.com>, Jeff Layton <jlayton@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        sjayaraman@novell.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A while ago this was discussed:

  http://thread.gmane.org/gmane.linux.kernel.cifs/7779

This is essentially a regression introduced by the shared superblock
changes in 3.0 and several SUSE customers are complaining about it.
I've created a temporary fix which reverts 29 commits related to the
shared superblock changes.  It works, but it's obviously not a
permanent fix, especially since we definitely don't want to diverge
from mainline.

Is this issue being worked on?  Don't other distros have similar reports?

Thanks,
Miklos
