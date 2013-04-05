Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161610Ab3DEGk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 02:40:58 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:52030 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3DEGk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 02:40:56 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.123.88]
In-Reply-To: <1364510053-29347-1-git-send-email-rtivy@ti.com>
References: <1364510053-29347-1-git-send-email-rtivy@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 5 Apr 2013 09:40:35 +0300
Message-ID: <CAK=Wgba-iqusCy4WD_io4XKUzDeje84pgUV52+O7NO8iL1BEWw@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: Fix bug in rproc_alloc_vring() with
 idr_alloc() return value
To: Robert Tivy <rtivy@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 12:34 AM, Robert Tivy <rtivy@ti.com> wrote:
> rproc_alloc_vring() was modified to call idr_alloc() instead of
> idr_get_new(), but the return value was still handled as before.
>
> Signed-off-by: Robert Tivy <rtivy@ti.com>

Thanks Rob. This was submitted by Suman some time ago and was applied.
I'll be sending it to Linus very soon now.
