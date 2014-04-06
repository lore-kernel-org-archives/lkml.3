Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbaDFVOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 17:14:20 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:56711 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbaDFVOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 17:14:16 -0400
Message-ID: <1396818854.7118.3.camel@x220>
Subject: Re: Kconfig circular dependency question
From: Paul Bolle <pebolle@tiscali.nl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Date: Sun, 06 Apr 2014 23:14:14 +0200
In-Reply-To: <5341C22A.1050907@lwfinger.net>
References: <5341AFC7.1070001@lwfinger.net> <5341B999.3050206@infradead.org>
	 <1396817575.4886.23.camel@x220> <5341C22A.1050907@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Apr 2014 21:14:14.0852 (UTC) FILETIME=[29D59840:01CF51DD]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-06 at 16:07 -0500, Larry Finger wrote:
> As you have seen in my reply to Randy, this appears to arise from violating one 
> of the edicts of Linus that says that no configuration variable should select a 
> subsystem. Of course, one could argue that RFKILL is also a subsystem, and that 
> R8723AU should depend on it rather that selecting it.
> 
> My day also seems to be slowing. :)

Would you mind sharing the .config that triggered this? (I guess I also
need to know the make command you ran.) Than I could play with this, on
a not so slow day, and maybe, just maybe, understand what's going on.


Paul Bolle

