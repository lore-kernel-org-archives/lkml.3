Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaDYOL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:11:26 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:47845 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaDYOLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:11:19 -0400
MIME-Version: 1.0
In-Reply-To: <1398432935.28366949@f70.i.mail.ru>
References: <1398387367-4047-1-git-send-email-jon@ringle.org>
	<alpine.LRH.2.03.1404250914380.30160@frank.harvard.edu>
	<1398432935.28366949@f70.i.mail.ru>
Date: Fri, 25 Apr 2014 10:11:18 -0400
X-Google-Sender-Auth: AanR8LDeYwcsNowFwODWxAvylhs
Message-ID: <CAMwGMjy4HjP6y4YH8+OiNaU5cWEFsTOgATno3rhQPYUczzbcSw@mail.gmail.com>
Subject: Re: [PATCH v7 1/2] serial: sc16is7xx
From: Jon Ringle <jon@ringle.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Charles Coldwell <coldwell@gmail.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jon Ringle <jringle@gridpoint.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 9:35 AM, Alexander Shiyan <shc_work@mail.ru> wrote:
> And it would be nice to have a small changelog,
> because it is unclear what has changed with version 6.

v7 was created at Greg's request to refresh the patch. The only
conflict that required code change was in serial_core.h changing
#define PORT_SC16IS7XX 107
to
#define PORT_SC16IS7XX 108

Jon
