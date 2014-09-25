Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaIYTqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:46:18 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:43764 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaIYTqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:46:17 -0400
MIME-Version: 1.0
X-Originating-IP: [2a02:810d:740:57c:6a05:caff:fe03:ab31]
In-Reply-To: <1411660211-8303-1-git-send-email-mina86@mina86.com>
References: <1410471576-12053-1-git-send-email-mina86@mina86.com>
	<1411660211-8303-1-git-send-email-mina86@mina86.com>
Date: Thu, 25 Sep 2014 21:46:16 +0200
Message-ID: <CAPh34mcT1tcWFO316+6dxAEhWc7MzLU0Uq3ATXv4N3cf9z5DHA@mail.gmail.com>
Subject: Re: [PATCH] include: kernel.h: deduplicate code implementing clamp* macros
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mark Rustad <mark.d.rustad@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2014 17:50, Michal Nazarewicz <mina86@mina86.com> wrote:

> - * @min: minimum allowable value
> - * @max: maximum allowable value
> + * @lo: minimum allowable value
> + * @hi: maximum allowable value

Ok, but why do you rename min/max to low/high after so many years?
min/max is just perfect

Hagen
