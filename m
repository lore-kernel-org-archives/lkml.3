Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160AbaCWWbZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 18:31:25 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:54748 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaCWWbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 18:31:23 -0400
MIME-Version: 1.0
Date: Sun, 23 Mar 2014 15:31:23 -0700
Message-ID: <CAK7N6vrgnNdFvo8as+DrhXurxP+SexN9gi3WFrX_SCO9i2Ybyw@mail.gmail.com>
Subject: Disabling gcc inline operation
From: anish singh <anish198519851985@gmail.com>
To: LAK <linux-arm-kernel@lists.infradead.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many a time i have got a crash and it is difficult
to find out the exact function which crashed
because the crash stack doesn't show the "real"
function because gcc inlines many functions when
ever it desires or when it optimizes for speed.

So i don't want gcc to inline any function instead
just call the function so that i can see the crash
stack of each function called. I just want to do
this for debugging. Please let me know how can
i do that?

What switch command to pass to gcc in the make
of linux kernel?
