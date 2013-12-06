Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab3LFRWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 12:22:04 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:44577 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab3LFRWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:22:02 -0500
MIME-Version: 1.0
Date: Fri, 6 Dec 2013 21:22:01 +0400
Message-ID: <CABWXVkMdyDNxG3QFOvyx4=6EiJQ5ik9aJxa7jQvtO+UJKwc8Fw@mail.gmail.com>
Subject: synaptics: PS/2 touchpad isn't detected if a keyboard key is held
 down on boot
From: Andrey Moiseev <o2g.org.ru@gmail.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an ancient bug, I noticed it since I bought my notebook.
Synaptics PS/2 touchpad is not detected and is not shown in
/dev/input/event* if I hold a keyboard key down when booting just
started.
