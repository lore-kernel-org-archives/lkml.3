Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaIWKlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:41:00 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:50042 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbaIWKk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:40:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "LF.Tan" <lftan.linux@gmail.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Ley Foon Tan <lftan@altera.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH v3 01/29] asm-generic: add generic futex for !CONFIG_SMP
Date: Tue, 23 Sep 2014 12:40:54 +0200
Message-ID: <13000968.l0laEvMsix@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAFiDJ5-b_P7aWFXYP4GcgTUb3t_j6dZCsjeGZwVUs+7qo0v-GA@mail.gmail.com>
References: <1410168160-3624-1-git-send-email-lftan@altera.com> <1410168160-3624-2-git-send-email-lftan@altera.com> <CAFiDJ5-b_P7aWFXYP4GcgTUb3t_j6dZCsjeGZwVUs+7qo0v-GA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:1yZZT1Pa1haLQ+X5jIh2FZ+zJfo+Pm4U3/5I3YuEw+i
 NqsryARQgBNfL7W89gpCRY0AaAUTYnaUI7othGnCEBv9mbUpCI
 QeD9uzUqmX8+z1PbG5yzzxWNKZLB6QBHEbHnv6aRbA/lus1B1n
 pWW4LCzT9kjJZG741f/xcfLZ4AXIksPIsb7ws7dyqKHtWNwly9
 g8kIno/qLvZMpAK6nv4HhLJDlliuNkf+dXuK/mCCRFLB8ivTgn
 FFFAKUFtnXDNjZ3Sh2ZP3ERbVfmtSWTjByARSEHn/kNytxZsIA
 8vEQGcwpifuBYjX/InKpKEt+yzWv47UPeklYbAYFLXePvKzUPk
 W2iymq5ZBupu9DWAcsvY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 18:20:08 LF.Tan wrote:
> Hi Arnd
> 
> Are you okay with this generic futex in asm-generic?
> 

Yes, this looks good. Remind me again who need this, would it make
sense to merge this through an architecture-specific tree for
whichever architecture can benefit from it?

	Arnd
