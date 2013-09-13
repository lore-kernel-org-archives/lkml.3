Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3IMTdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 15:33:39 -0400
Received: from dkim2.fusionio.com ([66.114.96.54]:51726 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3IMTdh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 15:33:37 -0400
X-ASG-Debug-ID: 1379100816-0421b502203b75a0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Mark Fasheh <mfasheh@suse.de>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130913175801.GL31381@wotan.suse.de>
CC: Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, Zach Brown <zab@redhat.com>
References: <20130913133314.GA20461@roeck-us.net>
 <CAMuHMdWoNo9U0DCRoXt8V2d1SiSxX5Sku9rNvg+9MiX++XjVRg@mail.gmail.com>
 <20130913163535.GA5681@roeck-us.net>
 <20130913170022.18785.82013@localhost.localdomain>
 <20130913175801.GL31381@wotan.suse.de>
Message-ID: <20130913193334.18785.8623@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: Re: Build failures due to commit 416161db (btrfs: offline dedupe)
Date: Fri, 13 Sep 2013 15:33:34 -0400
X-ASG-Orig-Subj: Re: Build failures due to commit 416161db (btrfs: offline dedupe)
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: UNKNOWN[10.101.1.41]
X-Barracuda-Start-Time: 1379100816
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.140580
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mark Fasheh (2013-09-13 13:58:01)
> On Fri, Sep 13, 2013 at 01:00:22PM -0400, Chris Mason wrote:
> > Quoting Guenter Roeck (2013-09-13 12:35:35)
> > I'm happy to fix this with a bigger put of the info struct, just
> > let me know the preferred arch-happy solution.
> 
> In fact old versions of the patch were putting the whole struct but during
> review I was asked to change it. This should be very straight forward to fix
> so long as we all stay calm ;)
>         --Mark

Mark, could you please send a patch for the whole-struct option until
the unaligned put is upstreamed?

-chris

