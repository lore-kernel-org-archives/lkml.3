Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbaAFVYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:24:05 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:51156 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbaAFVYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:24:03 -0500
MIME-Version: 1.0
In-Reply-To: <20140106211115.GA23421@amd.pavel.ucw.cz>
References: <CALkWK0n0q+a9EmMbJXsgo6eO1B+0Lq6tqsN3moLbXz+Y0GGu0g@mail.gmail.com>
 <20140106211115.GA23421@amd.pavel.ucw.cz>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 7 Jan 2014 02:47:18 +0530
Message-ID: <CALkWK0nLg9D+4=_eNe3cgmnuzzZgk+E5U_OK9vh6_3XTZSX12w@mail.gmail.com>
Subject: Re: [QUERY] Power consumption on a 2013 MBP
To: Pavel Machek <pavel@ucw.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> USB usually does that. Try rmmoding hcd(s). If that does not help, try
> removing other modules. Oh and try without that broadcom-wl driver.

Unused modules shouldn't consume so much power, no? I suspected
broadcom-wl, but removing it doesn't help. Instead of shooting in the
dark, is there some tool that I can use to figure out the culprits?

Thanks.
