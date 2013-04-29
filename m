Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860Ab3D2VmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:42:11 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:62218 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749Ab3D2Vl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:41:59 -0400
MIME-Version: 1.0
In-Reply-To: <201304291521.14195.arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
 <1366910944-3033663-11-git-send-email-arnd@arndb.de> <CALZLnaFeLcaGM7_McTZ=pKBRnpXk0AvqOTF=1YCqJv-53yk4XQ@mail.gmail.com>
 <201304291521.14195.arnd@arndb.de>
From: Masanori Goto <gotom@sanori.org>
Date: Tue, 30 Apr 2013 06:41:38 +0900
X-Google-Sender-Auth: zTKLtSrpPtz4igZ14jRfVCiVRS8
Message-ID: <CALZLnaEbXRJY2qntWucm00mNq78CRD8Vhp7KoTw6Me0frxtaDw@mail.gmail.com>
Subject: Re: [PATCH 10/21] [SCSI] nsp32: use mdelay instead of large udelay constants
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, you're absolutely correct.  Thanks for the follow up!  Please
change it as follow as you mentioned:

Acked-by: GOTO Masanori <gotom@debian.or.jp>

Best regrads,
-- gotom

2013/4/29 Arnd Bergmann <arnd@arndb.de>:
> On Friday 26 April 2013, Masanori Goto wrote:
>> 2013/4/25 Arnd Bergmann <arnd@arndb.de>
>> >
>> > ARM cannot handle udelay for more than 2 miliseconds, so we
>> > should use mdelay instead for those.
>> >
>>
>> Singed-off-by: GOTO Masanori <gotom@debian.or.jp>
>
> Thanks. I assume you mean "Acked-by", not "Singed-off" as in "burnt"
> or "Signed-off" as a notification that you have applied it to your
> own git tree.
>
> I'll keep the patch with an your "Acked-by" line in my tree unless
> James wants to apply to the scsi tree.
>
>         Arnd
>
