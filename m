Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbbAZPxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:53:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbbAZPw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:52:57 -0500
From: Paul Moore <pmoore@redhat.com>
To: sedat.dilek@gmail.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Guenter Roeck <linux@roeck-us.net>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-audit@redhat.com,
        rgb@redhat.com, sd@queasysnail.net,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] Overhaul the audit filename handling
Date: Mon, 26 Jan 2015 10:52:49 -0500
Message-ID: <1670043.82pCAlqBeA@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <CA+icZUWOkW-ujARrnT4T3wsZh0EbkHR+p2q2c1-zJYKtP46hfA@mail.gmail.com>
References: <20150122045303.1347.98054.stgit@localhost> <20150123053056.GC29656@ZenIV.linux.org.uk> <CA+icZUWOkW-ujARrnT4T3wsZh0EbkHR+p2q2c1-zJYKtP46hfA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 24, 2015 10:03:06 AM Sedat Dilek wrote:
> I have tested vfs.git#getname2 on top of Linux v3.19-rc5-184-gc4e00f1
> (plus block-loopmq patchset) and it boots fine on Ubuntu/precise
> amd64.

Great, thank you for the additional testing.
 
> Just curious, where will this audit-filename-handling overhaul go through?
> Through Paul's audit-next or Al's vfs-next tree?

Al wanted to carry the patchset so that is where it lives now, you should see 
it arrive in Linus' tree via the VFS tree.

-- 
paul moore
security @ redhat

