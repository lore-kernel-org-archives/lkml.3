Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab3HTKja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 06:39:30 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:54609 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3HTKj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 06:39:29 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.03.1308201522230.15482@erqung.pbz>
References: <alpine.LFD.2.03.1308201522230.15482@erqung.pbz>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 20 Aug 2013 11:39:08 +0100
X-Google-Sender-Auth: g9-j7qC2k0AG3cBwKecNnrZTNxI
Message-ID: <CAHkRjk76V-RyJbm4mSNt6DLpLDv_wqcuag5Z_hSTcrcdUi=6jg@mail.gmail.com>
Subject: Re: About perf,arm -- oops in validate_event
To: P J P <ppandit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        vincent.weaver@maine.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 August 2013 11:03, P J P <ppandit@redhat.com> wrote:
>  -> https://lkml.org/lkml/2013/8/7/259
>
> I wanted to confirm if this above fix should also go into ARM64 build Or is
> ARM64 platform not vulnerable?

It is and I'll push patches to mainline (Will is preparing them).

Catalin
