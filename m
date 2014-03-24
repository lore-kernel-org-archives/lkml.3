Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbaCXNlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 09:41:46 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:38922 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbaCXNlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 09:41:45 -0400
MIME-Version: 1.0
Date: Mon, 24 Mar 2014 16:41:43 +0300
Message-ID: <CACVxJT8YFTimO-XeQt--zezwvrwEVCRqmN5ocOoGuWuJkzTQVw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] procfs: make /proc/*/{stack,syscall,personality} 0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: tixxdz@opendz.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - ONE("stack",      S_IRUGO, proc_pid_stack),
> + ONE("stack",      S_IRUSR, proc_pid_stack),

no love for /proc/*/wchan?
