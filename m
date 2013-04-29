Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab3D2NVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 09:21:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59447 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757788Ab3D2NVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 09:21:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Masanori Goto <gotom@sanori.org>
Subject: Re: [PATCH 10/21] [SCSI] nsp32: use mdelay instead of large udelay constants
Date: Mon, 29 Apr 2013 15:21:14 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de> <1366910944-3033663-11-git-send-email-arnd@arndb.de> <CALZLnaFeLcaGM7_McTZ=pKBRnpXk0AvqOTF=1YCqJv-53yk4XQ@mail.gmail.com>
In-Reply-To: <CALZLnaFeLcaGM7_McTZ=pKBRnpXk0AvqOTF=1YCqJv-53yk4XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304291521.14195.arnd@arndb.de>
X-Provags-ID: V02:K0:QJ5RT3/MAhS7RKscEN7skQ/XE0QCtcMob+ZfhzftVQa
 67fe88zoi8dvLWhu8CMKHcYovhdCZrsD0rsb5BgqFcRMxTrPXp
 gpYV83QABm2WY1bXyE9sKq4oAUilOild1QNrR268HmECRcZRAB
 +iHKVCAE/C2bi/51uDGgImSSLST/zLvBlVcX99g9Ev06BAPztV
 cbbsLcR3Fqbrd2uNrs2UxTztY99QsuwkPbT4JVItjm37pslihf
 eWS+Yc8AWw4xtwYQLBJbMmyGs4XyOGT4cSt4KH0JQgtNtbjeNd
 PeyyiV94l0N6L8xGQcOj3PJnot9hlpucoCjqMK9kbcIUXV3y7b
 wugd8rkiV+uPVfV/bBqs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 April 2013, Masanori Goto wrote:
> 2013/4/25 Arnd Bergmann <arnd@arndb.de>
> >
> > ARM cannot handle udelay for more than 2 miliseconds, so we
> > should use mdelay instead for those.
> >
> 
> Singed-off-by: GOTO Masanori <gotom@debian.or.jp>

Thanks. I assume you mean "Acked-by", not "Singed-off" as in "burnt"
or "Signed-off" as a notification that you have applied it to your
own git tree.

I'll keep the patch with an your "Acked-by" line in my tree unless
James wants to apply to the scsi tree.

	Arnd
