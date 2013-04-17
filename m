Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966273Ab3DQSLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 14:11:36 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:47285 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964924Ab3DQSLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 14:11:35 -0400
MIME-Version: 1.0
In-Reply-To: <1366102254-12440-1-git-send-email-mmarek@suse.cz>
References: <1366102254-12440-1-git-send-email-mmarek@suse.cz>
Date: Wed, 17 Apr 2013 11:11:34 -0700
X-Google-Sender-Auth: pqg_0FGEjUSIZJbjYoexx4ntEyM
Message-ID: <CAPnjgZ3dNT0i4A+AocCSxQU-2v_emDwpFAJyAAZsWgO7fxnLGw@mail.gmail.com>
Subject: Re: [PATCH] input: Export matrix_keypad_parse_of_params()
From: Simon Glass <sjg@chromium.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Randy Dunlap <rdunlap@infradead.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        lk <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 1:50 AM, Michal Marek <mmarek@suse.cz> wrote:
> Couple of input drivers depend on this symbol:
>
> ERROR: "matrix_keypad_parse_of_params" [drivers/input/keyboard/tca8418_keypad.ko] undefined!
> ERROR: "matrix_keypad_parse_of_params" [drivers/input/keyboard/cros_ec_keyb.ko] undefined!
>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Acked-by: Simon Glass <sjg@chromium.org>
