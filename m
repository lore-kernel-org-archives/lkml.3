Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaBNK0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:26:44 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:61459 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaBNK0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:26:42 -0500
Date: Fri, 14 Feb 2014 02:26:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Weijie Yang <weijie.yang@samsung.com>
cc: gregkh@linuxfoundation.org, anton.vorontsov@linaro.org,
        weijie.yang.kh@gmail.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] staging: android: lowmemorykiller: set TIF_MEMDIE
 before send kill sig
In-Reply-To: <000001cf294a$b1bebd60$153c3820$%yang@samsung.com>
Message-ID: <alpine.DEB.2.02.1402140226280.12099@chino.kir.corp.google.com>
References: <000001cf294a$b1bebd60$153c3820$%yang@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014, Weijie Yang wrote:

> Set TIF_MEMDIE tsk_thread flag before send kill signal to the
> selected thread. This is to fit a usual code sequence and avoid
> potential race issue.
> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

Acked-by: David Rientjes <rientjes@google.com>
