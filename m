Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab3KMNZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 08:25:22 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:64602 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab3KMNZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 08:25:20 -0500
MIME-Version: 1.0
In-Reply-To: <20131113125734.GA22140@gmail.com>
References: <1384345308-24404-1-git-send-email-penberg@kernel.org>
	<20131113125734.GA22140@gmail.com>
Date: Wed, 13 Nov 2013 15:25:18 +0200
X-Google-Sender-Auth: ZMJnsdcGw3JKCh5wfTIwCteSKOo
Message-ID: <CAOJsxLEFVwiz3pwKoJdy3ARKd_Rk0Mkcy7k62ZqJJE9_f5s2RQ@mail.gmail.com>
Subject: Re: [PATCH] perf trace: Tweak summary output
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 2:57 PM, Ingo Molnar <mingo@kernel.org> wrote:
> Are you convinced about double-digit precision output for percentages?
>
> I think it suggest a false level of accuracy, but YYMV - typographically
> xx.yy certainly looks nicer than xx.y (it's more symmetric).

Yeah, I think it's OK.

                        Pekka
