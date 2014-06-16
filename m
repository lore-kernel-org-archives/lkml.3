Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239AbaFPUlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:41:45 -0400
Received: from mout.gmx.net ([212.227.15.18]:54398 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbaFPUlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:41:44 -0400
Message-ID: <539F567F.2050802@gmx.de>
Date: Mon, 16 Jun 2014 22:41:35 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Eric Paris <eparis@redhat.com>, Richard Weinberger <richard@nod.at>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.15: kernel BUG at kernel/auditsc.c:1525!
References: <539F1C59.6070308@gmx.de> <CAFLxGvyqPzbmfz1-WxP7z02=V-V5=p5b09HYPOFOS7Qj8eUHGw@mail.gmail.com> <CALCETrXqjHPvKw=wcdnxQWO0Y140B=a0E7eh4+PoERvU=z909w@mail.gmail.com> <539F297F.7010904@nod.at> <CALCETrU+TmaEjPSHz1LwQJvVDp8fqoDs3O4b+3gS_ewthiwnMA@mail.gmail.com> <539F2B2D.6050105@gmx.de> <CALCETrVw6f7iy4qTMgSt8k9N4rOWJ_mm9LbrtVZ9YFORacriSQ@mail.gmail.com> <539F3077.7040005@gmx.de> <CALCETrUUC6g_y4nJkSYo7MrKB8ehyXgnnuBHxGCDrq1d4zp2BQ@mail.gmail.com> <539F35A0.2050002@gmx.de> <CALCETrVseO=n6TH-msfTHRqB-OMPs_32nRELVYc=V1ZDmvFXVA@mail.gmail.com>
In-Reply-To: <CALCETrVseO=n6TH-msfTHRqB-OMPs_32nRELVYc=V1ZDmvFXVA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:hVeCCbnthueYnK/HPjnDByyUBfQCendy/mdaCpDCahcRx1BSpD6
 HIGNSLxMrKy+XTfN+ubvVIcixBLw5vqOvft9nJd1/q6cDXkMhIDTyPTpiW78rUgMTpbeTqY
 /h1SecOcAGLY2QlFi8e0fARn8UubB6CPRO/FRAFhy9I29WbIjxszhuZ85DNLbU5MPzjg1X1
 WWjPwcEoBxy7EtZNqefjg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, might be the mail:subject should be adapted, b/c the issue can be triggered in a 3.13.11 kernel too.
Unfortunately it does not appear within an UML guest, therefore an automated bisecting isn't possible I fear.

-- 
Toralf

