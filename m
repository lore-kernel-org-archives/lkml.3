Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab3FER5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:57:51 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35152 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374Ab3FER5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:57:49 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface via sysfs
Date: Wed, 05 Jun 2013 10:57:44 -0700
Message-ID: <7380889.l4hHqCT0mm@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.10.3 (Linux/3.9.4-200.fc18.x86_64; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1370453866-16534-11-git-send-email-nick.dyer@itdev.co.uk>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk> <1370453866-16534-11-git-send-email-nick.dyer@itdev.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Wednesday, June 05, 2013 06:37:03 PM Nick Dyer wrote:
> Atmel maXTouch chips can be addressed via an "Object Based Protocol" which
> defines how i2c registers are mapped to different functions within the
> chips. This interface exposes the register map and allows user-space
> utilities to inspect and alter object configuration, and to view diagnostic
> data, while the device is running.

I think if the driver was to use regmap then this fucntionality will already 
be there as regmap exports registers via debugfs.

Thanks.

-- 
Dmitry
