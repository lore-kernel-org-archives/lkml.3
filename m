Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab3IPF2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 01:28:12 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:43879 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab3IPF2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 01:28:11 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzJtybx3B=zcv1atCD-wUMc1YLdXndjX_d_ZxTDUpmOrQ@mail.gmail.com>
References: <1379049145-16017-1-git-send-email-realmz6@kernel.org>
	<CA+55aFzJtybx3B=zcv1atCD-wUMc1YLdXndjX_d_ZxTDUpmOrQ@mail.gmail.com>
Date: Mon, 16 Sep 2013 13:28:10 +0800
Message-ID: <CAJxxZ0OEGSw+0a0skLCuSham2R+Q3UR=f=Ddf1-SeqS2qbE9zg@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [GIT PULL] Blackfin updates for 3.12
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Miao <realmz6@kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Sep 13, 2013 at 10:29 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Sep 12, 2013 at 10:12 PM, Steven Miao <realmz6@kernel.org> wrote:
>>  arch/blackfin/mach-bf609/Kconfig                   | 1655 ++++++++++++++++++++
>
> WTF? This is getting crazy. The blackfin board Kconfig files are being
> used as a DT replacement. This can't go on.
>

I am sorry to put many config options into the Blackfin Kconfig file.
In the case this is not preferred, we will make sure no more device
config options are put into the Kconfig files.

Thanks for your guide.


Sonic
