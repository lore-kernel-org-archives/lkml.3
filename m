Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbaIWHc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:32:27 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:44664 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbaIWHcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:32:23 -0400
MIME-Version: 1.0
From: Mike Lothian <mike@fireburn.co.uk>
Date: Tue, 23 Sep 2014 08:32:02 +0100
Message-ID: <CAHbf0-HyGUPcc14HwBjmQnQV9Mauxur3=5O_MqyGmiV9NK4Pnw@mail.gmail.com>
Subject: Hard lockups under high CPU load with DynTicks - RCU Related?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've raised https://bugzilla.kernel.org/show_bug.cgi?id=84131 and
attempted to bisect

The bug I'm stumbling on happens on both and Intel Sandybridge and AMD
Kabini system - it manifests itself as a hard lockup when the system
is under high load

If I switch off DynTicks the problem doesn't happen - I bisected by
compiling Chromium marking each one good or bad if the system starts
to lockup

I'm not sure if I've filed the bug under the right Product / Component

Please let me know if you'd like any more diagnostics

Cheers

Mike
