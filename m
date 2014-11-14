Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbaKNKJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:09:11 -0500
Received: from mout.web.de ([212.227.17.12]:52707 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbaKNKJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:09:09 -0500
Message-ID: <5465D4B2.4020000@users.sourceforge.net>
Date: Fri, 14 Nov 2014 11:08:50 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>, Joe Perches <joe@perches.com>
CC: Coccinelle <cocci@systeme.lip6.fr>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Cocci] spatch for trivial pointer comparison style?
References: <1415908529.4223.11.camel@perches.com> <alpine.DEB.2.02.1411140700010.2035@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1411140700010.2035@localhost6.localdomain6>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ewlkaDKefEqOMlHOzv+7/nUNDs9rit46J81noo0u6AZe1+JGQfJ
 2Oto06XkCW9PEfH74w/YR0w7Iab3KUclV28P7/gPfZ6RmJ3Ni6A5892VggLa1DS4i/fr8CO
 8l5Qxy5aWJ/BINuUArAcNxmz0IUxqUdp/Kv9jibOrCMkOwnqOyFp9QhpsH4XUAGTuD1BNLw
 i/YnWPer8NOfd5GPNUFow==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think that the change is desirable in all cases.  There are
> functions like kmalloc where NULL means failure and !p seems like the
> reasonable choice.  But there maybe other cases where NULL is somehow
> a meaningful value.

How do you think about to adjust checks for null pointers not only
in Linux source files but also in other applications?
Are there any more software design challenges to consider with the
definition of the preprocessor symbol "NULL"?

Regards,
Markus
