Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbaFPUnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:43:52 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521AbaFPUnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:43:51 -0400
Message-ID: <539F5702.5050104@nod.at>
Date: Mon, 16 Jun 2014 22:43:46 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
        Andy Lutomirski <luto@amacapital.net>
CC: Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.15: kernel BUG at kernel/auditsc.c:1525!
References: <539F1C59.6070308@gmx.de> <CAFLxGvyqPzbmfz1-WxP7z02=V-V5=p5b09HYPOFOS7Qj8eUHGw@mail.gmail.com> <CALCETrXqjHPvKw=wcdnxQWO0Y140B=a0E7eh4+PoERvU=z909w@mail.gmail.com> <539F297F.7010904@nod.at> <CALCETrU+TmaEjPSHz1LwQJvVDp8fqoDs3O4b+3gS_ewthiwnMA@mail.gmail.com> <539F2B2D.6050105@gmx.de> <CALCETrVw6f7iy4qTMgSt8k9N4rOWJ_mm9LbrtVZ9YFORacriSQ@mail.gmail.com> <539F3077.7040005@gmx.de> <CALCETrUUC6g_y4nJkSYo7MrKB8ehyXgnnuBHxGCDrq1d4zp2BQ@mail.gmail.com> <539F35A0.2050002@gmx.de> <CALCETrVseO=n6TH-msfTHRqB-OMPs_32nRELVYc=V1ZDmvFXVA@mail.gmail.com> <539F567F.2050802@gmx.de>
In-Reply-To: <539F567F.2050802@gmx.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.06.2014 22:41, schrieb Toralf Förster:
> Well, might be the mail:subject should be adapted, b/c the issue can be triggered in a 3.13.11 kernel too.
> Unfortunately it does not appear within an UML guest, therefore an automated bisecting isn't possible I fear.

You could try KVM. :)

Thanks,
//richard
