Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab3ETVDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 17:03:33 -0400
Received: from mout.gmx.net ([212.227.15.15]:49233 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690Ab3ETVDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 17:03:32 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/gsOx9aa3g/CU2U1w0KrT8DG7OR13Q1utH61DWKH
	b5fGODYF7tVjvI
Message-ID: <519A8FA1.8040007@gmx.de>
Date: Mon, 20 May 2013 23:03:29 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130516 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: fuzz testing lets kernel audit complains in the linkat syscall
 only
References: <519A88BE.8030309@gmx.de>
In-Reply-To: <519A88BE.8030309@gmx.de>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 10:34 PM, Toralf Förster wrote:
> While fuzz testing a 3.9.3 kernel I'm wonder why the kernel audit does complain
> about a file in the syscall "unlinkat" - but audit does not complain when that file
> was created/modified etc.

sry - forget that mail, symlinkat and readlinkat give now audit logs too.


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
