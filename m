Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaCHB5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:57:32 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:34234 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaCHB5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:57:30 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 7 Mar 2014 17:57:09 -0800
Message-ID: <CALCETrWSyhJHwfKSBT3giSb0AtvHFBR9PYmhFhFJa=Yabw25iw@mail.gmail.com>
Subject: perf samples too long without perf running (?!?)
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On recent (3.13) kernels, I'm frequently getting messages like:

perf samples too long (2503 > 2500), lowering
kernel.perf_event_max_sample_rate to 50000

a few seconds to minutes after bootup.  As far as I know, I'm not
using perf.  What's going on here?

--Andy
