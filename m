Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab3EIDZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 23:25:58 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:58053 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab3EIDZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 23:25:56 -0400
MIME-Version: 1.0
In-Reply-To: <1368049529-8168-1-git-send-email-geert@linux-m68k.org>
References: <1368049529-8168-1-git-send-email-geert@linux-m68k.org>
Date: Wed, 8 May 2013 21:25:56 -0600
X-Google-Sender-Auth: zhdke8K9ljsbsP7vfIipJHkD-t4
Message-ID: <CAPnjgZ3Akf0+LKBt4c5HQX5c8PhL+zuvvHWrDpVj0W++GiOanA@mail.gmail.com>
Subject: Re: [PATCH] input: cros_ec_keyb_clear_keyboard() depends on CONFIG_PM_SLEEP
From: Simon Glass <sjg@chromium.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        lk <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 3:45 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> If CONFIG_PM_SLEEP is not set:
>
> drivers/input/keyboard/cros_ec_keyb.c:211: warning: ‘cros_ec_keyb_clear_keyboard’ defined but not used
>
> Move the definition of cros_ec_keyb_clear_keyboard() inside the section
> protected by #ifdef CONFIG_PM_SLEEP to fix this.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Simon Glass <sjg@chromium.org>
