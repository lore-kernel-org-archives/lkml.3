Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbbARPYl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 10:24:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbbARPYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 10:24:39 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Emil Renner Berthing <kernel@esmil.dk>,
        Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: rtl8723au: get rid of unneeded memset/memcpy
References: <1417963040-9014-1-git-send-email-kernel@esmil.dk>
	<20150117215040.GA16839@kroah.com>
Date: Sun, 18 Jan 2015 10:24:28 -0500
In-Reply-To: <20150117215040.GA16839@kroah.com> (Greg Kroah-Hartman's message
	of "Sat, 17 Jan 2015 13:50:40 -0800")
Message-ID: <wrfjzj9gt8lv.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> On Sun, Dec 07, 2014 at 03:37:20PM +0100, Emil Renner Berthing wrote:
>> This also fixes a sparse warning.
>
> What sparse warning?  What's wrong with the original code?  Unless Jes
> resends this to me, I don't see the need to apply it, sorry.

I agree, I cannot see what this is fixing, it does however add an ugly
cast.

If you want to change the paramters passed to FillH2CCmd() then change
the prototype and create something like struct h2c_cmd_arg{} and apply
that across the board.

NACK

Jes
