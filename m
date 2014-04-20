Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbaDTWFl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 18:05:41 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:53689 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaDTWFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 18:05:39 -0400
MIME-Version: 1.0
In-Reply-To: <c49c4ad2bfabfe75ac065f8ad878d697.squirrel@mungewell.org>
References: <1609685.QRL9N9sQvX@sigyn>
	<c49c4ad2bfabfe75ac065f8ad878d697.squirrel@mungewell.org>
Date: Mon, 21 Apr 2014 00:05:38 +0200
Message-ID: <CADbOyBSxHj80zA7UNq+yAtmSPgTqCXgOUUsQ30DQQ66cGw9egw@mail.gmail.com>
Subject: Re: [PATCH 0/24] Introduce ff-memless-next as an improved replacement
 for ff-memless
From: Elias Vanderstuyft <elias.vds@gmail.com>
To: Simon Wood <simon@mungewell.org>
Cc: =?UTF-8?B?TWljaGFsIE1hbMO9?= <madcatxster@devoid-pointer.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2014 at 7:27 PM,  <simon@mungewell.org> wrote:
> Hi all,
> I got a chance to build this series of patches and test with the
> controllers I have (*). Without specific instructions I wasn't sure
> exactly what to test, but it seems to be OK and the devices
> rumbled/wobbled appropriately,
> Simon
>
> tested-by: Simon Wood <simon@mungewell.org>
>
> * controllers:
> hid-sony: DS4, DS3SA, Intec
> hid-lg: WiiWheel, MomoRed, MomoBlack, DFP, WingMan Force

Did the WiiWheel have working FF_CONSTANT before this patchset?
It would be weird if yes, because lg4ff is also used for MOMO-Black
which works fine.

Elias
