Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab3FDR11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:27:27 -0400
Received: from linuxdingsda.de ([87.106.20.67]:43029 "EHLO serverteil.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752879Ab3FDR1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:27:25 -0400
Message-ID: <51AE2378.507@linuxdingsda.de>
Date: Tue, 04 Jun 2013 19:27:20 +0200
From: Tobias Winter <tobias@linuxdingsda.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] raise the maximum number of usb-serial devices to 512
References: <20130604024959.GA10697@kroah.com>
In-Reply-To: <20130604024959.GA10697@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.06.2013 04:49, Greg KH wrote:
> Tobias, can you test this patch out?  Note, I only compiled it, did not
> get the chance to actually run it, so it might not work at all.

Sure, I'll gladly give it a try. Seeing the comments on the code, I'm
just wondering if there might be a more recent version to run?

> But I'm not so sure anymore, so here's a patch to change to use the
> idr code, and should remove all minor number limitations (well 65k is
> the limit the tty core should be setting I think.)

That's a tough one to break :)

Tobias
