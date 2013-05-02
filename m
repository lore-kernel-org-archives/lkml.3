Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab3EBUhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 16:37:38 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:37479 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932619Ab3EBUhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 16:37:37 -0400
Message-ID: <1367527048.11375.12.camel@jlt4.sipsolutions.net>
Subject: Re: Fw: kernel BUG at net/rfkill/core.c:244!
From: Johannes Berg <johannes@sipsolutions.net>
To: Roberto CORRADO <i@secure.corradoroberto.it>
Cc: IvDoorn@gmail.com, linux-kernel@vger.kernel.org
Date: Thu, 02 May 2013 22:37:28 +0200
In-Reply-To: <B42257E8CA4E4C23957DC087358A7ECA@unknown>
References: <B42257E8CA4E4C23957DC087358A7ECA@unknown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-30 at 20:02 +0200, Roberto CORRADO wrote:
> [    8.910064] ------------[ cut here ]------------
> [    8.911030] kernel BUG at net/rfkill/core.c:244!

BUG_ON(!rfkill);

Arguably, it need not BUG_ON(), but you should talk to somebody else:

> [    8.911030]  [<f863122f>] hp_wmi_bios_setup+0x22f/0x34d [hp_wmi]

johannes

