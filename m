Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaI2JAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:00:12 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:50191 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751221AbaI2JAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:00:10 -0400
Message-ID: <1411981207.6334.6.camel@x220>
Subject: Re: [PATCH] unicore32: Remove unneeded Kconfig entry NO_IOPORT_MAP
From: Paul Bolle <pebolle@tiscali.nl>
To: Xuetao Guan <gxt@pku.edu.cn>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Date: Mon, 29 Sep 2014 11:00:07 +0200
In-Reply-To: <1373895763.5110.1411868969556.JavaMail.root@bj-mail03.pku.edu.cn>
References: <1373895763.5110.1411868969556.JavaMail.root@bj-mail03.pku.edu.cn>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2014 09:00:07.0955 (UTC) FILETIME=[C48A7E30:01CFDBC3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-09-28 at 09:49 +0800, Xuetao Guan wrote:
> Sorry for late reply.

You replied within four days. That's rather quick, actually.

> I checked this config, and it's only used for HAS_IOPORT_MAP in lib/Kconfig
> Sure, removing it means no different for .config file.
> I think a better way is reserving it

I'm not sure I get what you're saying here: what do mean with "reserving
it"?

> or moving it into arch/Kconfig

Without a (treewide) patch I find it hard to say whether that's worth
the trouble. But even if that move would be done, wouldn't it include
dropping this entry from arch/unicore32 anyway?


Paul Bolle

