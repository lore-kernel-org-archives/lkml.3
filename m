Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467Ab3BGXNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 18:13:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52437 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab3BGXNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 18:13:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Thu, 7 Feb 2013 23:12:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, dahinds@users.sourceforge.net
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <201302070833.15443.arnd@arndb.de> <CAHTX3dLuAhpy-Yk10scRKrfRrbh+ZZs-hgFLAFn0Vj562V0Cew@mail.gmail.com>
In-Reply-To: <CAHTX3dLuAhpy-Yk10scRKrfRrbh+ZZs-hgFLAFn0Vj562V0Cew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302072312.45988.arnd@arndb.de>
X-Provags-ID: V02:K0:pi8Y7YDOJ5bJMGVORi3k3MD8otrO21cDDx46SbPpJsm
 SU8R82HHXErfTZiow1jlWRs1nT9LthRAubBVhltNicuKyW+v8P
 vfK+J+/YyrYCyK1HnCPQtE7Em0z/txjYxpg2YHdAlPr4EyjI8O
 +GZnETqw0ntYlsBpwGa8ARCbEa42xUPkFrTApRvjXdnIGEuPg8
 jj+pkz72Vl07iXLhh+aYgXcZsvueQlw91ZXHEu/AXgExaI0ivr
 k8UHExE5svRY23SRKtReZEeNRQ8x77hE5knISR0fXklkqY2UJs
 ioqBDbj0Sttui7oWQroBTW0LVk09w6W1M0+pgFi1gNZUn+DTlf
 SKXebyLmZ4MNMD4c7JWk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013, Michal Simek wrote:
> Subject: "asm-generic: io: Fix ioread16/32be and iowrite16/32be"

Ok, thanks. If you don't mind, I think this can just go with the other patches
for xsysace that come out of this discussion.

	Arnd
