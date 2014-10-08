Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbaJHJ0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:26:17 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:51180 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbaJHJ0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:26:15 -0400
MIME-Version: 1.0
Date: Wed, 8 Oct 2014 10:26:14 +0100
Message-ID: <CAB4+1U3upf8-03PD-y5K1oAhtDQFjLyEAGS_-PfZBu6bc88aPA@mail.gmail.com>
Subject: ftrace: trace buffer size configuration
From: sabra gargouri <sabra3982@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'am using ftrace to trace my system for a few minutes. For that I
configured the trace buffer via buffer_size_kb file to 100000 kb so 200000
for 2 CPUs. After tracing my system the trace size is 500MB.
Why the allocated size for the trace buffer (200 MB) is not the same of the
trace file (500 MB) ?

and is it convenient to allocate such a big size for the buffer?

Best regards
