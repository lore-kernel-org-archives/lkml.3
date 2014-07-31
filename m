Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbaGaJUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 05:20:19 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:47031 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098AbaGaJUR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:20:17 -0400
MIME-Version: 1.0
In-Reply-To: <3335238.KGDcEM6DjH@sigyn>
References: <3335238.KGDcEM6DjH@sigyn>
Date: Thu, 31 Jul 2014 11:20:15 +0200
Message-ID: <CADbOyBQJjnOGfGJ4wwrtX=70V4-rkf_G8_8zP_eTdfD1y-8FYw@mail.gmail.com>
Subject: Re: PATCH hid: Implement mode switching on Logitech gaming wheels
 accordingly to the documentation
From: Elias Vanderstuyft <elias.vds@gmail.com>
To: =?UTF-8?B?TWljaGFsIE1hbMO9?= <madcatxster@devoid-pointer.net>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Edwin Velds <edwin@velds.nl>,
        "simon@mungewell.org" <simon@mungewell.org>,
        Roland Bosa <rbosa@logitech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 12:10 PM, Michal Malý
<madcatxster@devoid-pointer.net> wrote:
> Implement mode switching on Logitech gaming wheels accordingly to the documentation
>
> Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>

Tested all lg4ff_switch_force_mode
modes (0, 1, 2, 3, default), on both:
- MOMO (Black) : PID 0xCA03
- Formula Vibration : PID 0xCA04

Behaviour didn't deviate from normal, which is as expected because
these devices don't use the native versus compatibility mode,
according to the documentation.
So I consider this patch successful for these devices:

Tested-by: Elias Vanderstuyft <elias.vds@gmail.com>

Elias
