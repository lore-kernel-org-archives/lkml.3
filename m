Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbbAPWH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 17:07:28 -0500
Received: from mail-oi0-f54.google.com ([209.85.218.54]:61223 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbbAPWH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 17:07:26 -0500
MIME-Version: 1.0
In-Reply-To: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
Date: Fri, 16 Jan 2015 17:07:25 -0500
X-Google-Sender-Auth: uGiHQocE0207aovo0gdCoO_XaIU
Message-ID: <CA+5PVA7idthaLM_VTLdLEU=z=mbYnEkdQOSGSXqdJHJTNAHkzA@mail.gmail.com>
Subject: Re: [PATCH v3 00/13] Add kdbus implementation
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>,
        Andy Lutomirski <luto@amacapital.net>, linux-api@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        daniel@zonque.or, David Herrmann <dh.herrmann@gmail.com>,
        tixxdz@opendz.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 2:16 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This can also be found in a git tree, the kdbus branch of char-misc.git at:
>         https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-misc.git/

Is this now the canonical tree?  I ask because the github tree hasn't
been updated in quite some time.  The code.google.com tree has commits
from 2 days ago, but it still calls d_materialise_unique in fs.c
whereas the patchset you've posted uses the correct d_splice_alias.
So the code.google.com tree doesn't actually compile against 3.19-rcX.

I'm confused where we're supposed to track things now.

josh
