Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab3GVNm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 09:42:56 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:64882 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab3GVNmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 09:42:54 -0400
MIME-Version: 1.0
In-Reply-To: <51ED31AF.8000309@nod.at>
References: <1374258017-19606-1-git-send-email-artagnon@gmail.com>
 <51E988FF.9010201@nod.at> <CALkWK0kj=maJgrLV11h8GzJ-L24KWDzgCAiZa97rieJKUXeW_A@mail.gmail.com>
 <CALkWK0=0NWediExGCwJ3R-O+7V_9sgGzJPUaXgaTEka5O05N=Q@mail.gmail.com>
 <20130722124047.GL4165@ZenIV.linux.org.uk> <CALkWK0=bAwDxbLEtHOThjY58BmWCrFYgZm9GaLfEnF5vpu1VJw@mail.gmail.com>
 <51ED31AF.8000309@nod.at>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 22 Jul 2013 19:12:14 +0530
Message-ID: <CALkWK0ki0JN_uB3VNr=j0hAcEhiT_Xr+xd911-AGy5sjd95GFg@mail.gmail.com>
Subject: Re: [PATCH] um: change defconfig to stop spawning xterm
To: Richard Weinberger <richard@nod.at>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger wrote:
> "great user-experience" and other marketing buzzwords belong to Ubuntu land.

Ubuntu uses upstart; I have no idea why you brought it up.

> What technical problem are you facing?
> I'm using systemd distros all day on top of UML.

I started the thread with two patches [1][2].  Do the patches _not_
address problems?  Are the problems invalid in some way?  Are the
commit messages unclear?

[1]: http://lists.freedesktop.org/archives/systemd-devel/2013-July/012153.html
[2]: http://lists.freedesktop.org/archives/systemd-devel/2013-July/012154.html
