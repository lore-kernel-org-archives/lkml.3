Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab3H3LO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:14:59 -0400
Received: from gproxy4-pub.mail.unifiedlayer.com ([69.89.23.142]:58318 "HELO
	gproxy4-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754757Ab3H3LO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:14:57 -0400
X-Sender-Id: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 109.188.126.21 authed with slava@dubeyko.com}
Message-ID: <1377860886.4545.5.camel@slavad-ubuntu>
Subject: Re: [PATCH] add exFAT driver
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Reply-To: slava@dubeyko.com
To: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Fri, 30 Aug 2013 15:08:06 +0400
In-Reply-To: <20130830124622.5f81b7d4@rechenknecht2k7>
References: <20130830124622.5f81b7d4@rechenknecht2k7>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 109.188.126.21 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-30 at 12:46 +0200, Benjamin Valentin wrote:
> Samsung released their exFAT (and FAT12/16/32) driver under the GPLv2, it is
> based on the in-kernel FAT driver and can be obtained from [1].
> This patch adds version 1.2.4 of the exfat driver, sans the ifdefs for older
> kernel versions and ported to Linux 3.11.
> 
> [1] http://opensource.samsung.com search for exfat
> 
> original authors: Joosun Hahn
> 		  Sung-Kwan Kim
> 
> Signed-off-by: Benjamin Valentin <benpicco@zedat.fu-berlin.de>

Why original authors don't participate in submission of driver?

Anyway, it makes sense to prepare patch set instead of one huge patch.
Could you, please, prepare patch set?

And you should add linux-fsdevel list in CC for any discussion about
file system drivers.

Thanks,
Vyacheslav Dubeyko.

