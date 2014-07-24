Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbaGXPqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:46:46 -0400
Received: from mailsec108.isp.belgacom.be ([195.238.20.104]:64430 "EHLO
	mailsec108.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759268AbaGXPqo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:46:44 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=UGN7JNw3bPEHpwjh5ACRRBK85/3fvewMg9DN/Z6sboU= c=1 sm=2
 a=B_PqQitLs8kA:10 a=IkcTkHD0fZMA:10 a=_nzHzCNtrw6siiUAFr4A:9
 a=QEXdDO2ut3YA:10 a=0kPLrQdw3YYA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0HAIsp0VPD7hTU/2dsb2JhbABYgw6BKYJ4rFEBAQEBAQEGoSgBgQ0Wd4QDAQEEASNWBQsFBAIOCgICGA4CAlcGExGIKQyMPpwuhn+QSxeBLIRPiVAHgniBTgWvdYIDgUc7Lw
Date: Thu, 24 Jul 2014 17:46:42 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Oliver Neukum <oneukum@suse.de>
Cc: usb-storage@lists.one-eyed-alien.net, joe@perches.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Message-ID: <2081121229.1044862.1406216802363.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <1406201840.729.4.camel@linux-fkkt.site>
References: <1406189939-6433-1-git-send-email-fabf@skynet.be> <1406201840.729.4.camel@linux-fkkt.site>
Subject: Re: [PATCH 00/10 linux-next] drivers/usb: remove unnecessary break
 after goto/return
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 24 July 2014 at 13:37 Oliver Neukum <oneukum@suse.de> wrote:
>
>
> On Thu, 2014-07-24 at 10:18 +0200, Fabian Frederick wrote:
> > Small patchset addressing break redundancy on drivers/usb branch
> > (suggested by Joe Perches).
>
> Frankly, that is not a good idea. Somebody will remove a "goto"
> and forget to readd the "break"

No problem ; checkpatch would give a warning anyway. See "Possible switch
case/default not preceeded by break or fallthrough comment"

Regards,
Fabian
>
>       Regards
>               Oliver
>
>
