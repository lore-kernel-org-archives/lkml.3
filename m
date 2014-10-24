Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbaJXQAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:00:41 -0400
Received: from mout.gmx.net ([212.227.17.22]:56499 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbaJXQAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:00:40 -0400
Message-ID: <544A77A0.5030603@gmx.de>
Date: Fri, 24 Oct 2014 18:00:32 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>
CC: virtualization@lists.linux-foundation.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: v3.18-rc1 32 bit KVM hangs early in boot process
References: <5445479C.4030201@gmx.de>	<5446858B.3040107@gmx.de> <CA+5PVA5MCRhwnkbNXpMmLzeM4G=aau0kuRU_wma-5T59M+2vkA@mail.gmail.com> <544A73ED.3080106@gmx.de>
In-Reply-To: <544A73ED.3080106@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:9z7fW+ZxMu4h3c8LjFt7xYQzwUgD6Sz3/SHornrtGLT2DbF0jEO
 XYSWl7QFGh3tMgOFM1N1dG8YgjTmEKnxKrxSQXJW2KrePGkBiCtxkCLnb7O+UAPq6LMadIg
 2BgV1ZNrWtdLlsBoWiIL48Aq1oWy6cAo9awWPkyEjOq6NzN2CO5ZKpl+De0HauiokLVxJXZ
 HJJcIMmHPPRPWIxZcLbwA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2014 05:44 PM, Toralf Förster wrote:
> I just reverted
> 
> $ grep commit virtcons_*
> virtcons_1.patch:commit f5866db64f341776c2d9ed48080f82459fea6a55
> virtcons_2.patch:commit 401bbdc901b268113d7c562616feb7fc37492aca
> 
> on top of -rc1 which solved the issue entirely here.

(but I had to disable autitd, b/c otherwise the boot of the 32 bit Gentoo KVM would hang during start of auditd (installed version 2.2.2)

-- 
Toralf
pgp key: 0076 E94E

