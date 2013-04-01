Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab3DAU0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:26:35 -0400
Received: from mout.gmx.net ([212.227.15.15]:62896 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756328Ab3DAU0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:26:34 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+VIUJHty2VKZGcyhyhXwJVgGGhDo2wmErt21tvX0
	EGcHFZMxEpyRvl
Message-ID: <5159ED75.4020709@gmx.de>
Date: Mon, 01 Apr 2013 22:26:29 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130309 Thunderbird/17.0.4
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: kernel 3.8.4 : kernel BUG at fs/locks.c:2093!   part #2
References: <514F31AF.3080709@gmx.de> <20130325220143.GD10887@fieldses.org> <20130326144640.GB3353@fieldses.org> <51536610.7010809@gmx.de> <20130327215727.GB27426@fieldses.org> <20130329184331.GH22307@fieldses.org>
In-Reply-To: <20130329184331.GH22307@fieldses.org>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2013 07:43 PM, J. Bruce Fields wrote:
> For now, though, this should fix the bug.
> 
> Thanks again for this testing.
With this patch applied on top of 3.8.5 the bug could not be reproduced
any longer (till now).

@Dave
Just Cc:'ed you for your trinity score card
:-)

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
