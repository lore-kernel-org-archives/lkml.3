Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaI3K7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:59:01 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:59503 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaI3K7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:59:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAEOkp47rz9-V_qZkOGDjfsZQj5bRHq2hf8dghS3xRcwdrP9UzQ@mail.gmail.com>
References: <CAEOkp47rz9-V_qZkOGDjfsZQj5bRHq2hf8dghS3xRcwdrP9UzQ@mail.gmail.com>
Date: Tue, 30 Sep 2014 16:28:53 +0530
Message-ID: <CAEOkp44Ee_ncmCTXmoF97M_m_K9Y1q+mQ17jO9cQQYJpnwFSCA@mail.gmail.com>
Subject: Re: Enabling ftrace on ARM MMU-less system
From: Amit Virdi <amitvi128@gmail.com>
To: fweisbec@gmail.com, rostedt@goodmis.org, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 4:26 PM, Amit Virdi <amitvi128@gmail.com> wrote:
> I'm trying to enable Ftrace on my ARM based MMU-less system.
> Unexpectedly, I don't see tracing directory under /sys/kernel/debug

I forgot to mention that I'm using read-only filesystem (cramfs).
