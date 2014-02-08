Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaBHUGA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 15:06:00 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:60588 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333AbaBHUF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 15:05:59 -0500
Message-ID: <1391889956.5420.4.camel@x41>
Subject: Re: [ath5k-devel] [PATCH] ath5k: Remove AHB bus support.
From: Paul Bolle <pebolle@tiscali.nl>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Adrian Chadd <adrian@freebsd.org>, Jonathan Bither <jonbither@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>,
        "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Sat, 08 Feb 2014 21:05:56 +0100
In-Reply-To: <CAB=NE6UR+3uadczBt+2n4g8j2e_A6OBJ-+ZJiO4y2g4Z0cFywg@mail.gmail.com>
References: <1320756113.14409.385.camel@x61.thuisdomein>
	 <20111108141647.GA3390@hash.lan>
	 <1342124352.22584.21.camel@x61.thuisdomein>
	 <20120712203837.GA3045@localhost> <4FFFBDD8.6020305@neratec.com>
	 <20120713124134.GA5567@localhost>
	 <1362999998.3137.60.camel@x61.thuisdomein>
	 <1368457391.1350.67.camel@x61.thuisdomein>
	 <CAJ-VmokciVPxzJ0LptdQyL9koa8Bw7ecJdentPH5q9+MQ4=GpA@mail.gmail.com>
	 <5191173D.3070709@gmail.com>
	 <CAJ-Vmo=HOFqu8vB1=pvz79YwE8qAMDc4ZJACJHaSuxn4S92sFg@mail.gmail.com>
	 <CAB=NE6UR+3uadczBt+2n4g8j2e_A6OBJ-+ZJiO4y2g4Z0cFywg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Feb 2014 20:05:56.0999 (UTC) FILETIME=[2DC71970:01CF2509]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez schreef op ma 13-05-2013 om 10:43 [-0700]:
> NACK, looking forward to the linux-mips patches, in the future however
> we want to avoid these type of placeholder patches.

This thread was (likely) started when I submitted this patch (to remove
AHB bus support) during the v3.10 development cycle. We're now at
v3.14-rc1, and the patch still applies (perhaps requiring some trivial
context changes).

Should I resubmit?


Paul Bolle

