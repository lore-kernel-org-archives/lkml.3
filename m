Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab3HAXkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 19:40:49 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:53793 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab3HAXks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 19:40:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAMP44s2LqiEGtS72FuTjsHUa1MH2kfaYHmcpNKMmAm2LnbFCCQ@mail.gmail.com>
References: <1375125658-1223-1-git-send-email-felipe.contreras@gmail.com>
	<3453253.oZLO1ChPbL@vostro.rjw.lan>
	<CAMP44s02V_FO1BPJZqo6MB9RMknXYdV7AXDqbJzYHpgK1GUuJw@mail.gmail.com>
	<37178266.QXgbv9rq0i@vostro.rjw.lan>
	<CAMP44s2LqiEGtS72FuTjsHUa1MH2kfaYHmcpNKMmAm2LnbFCCQ@mail.gmail.com>
Date: Thu, 1 Aug 2013 18:40:46 -0500
Message-ID: <CAMP44s1zDvUoVZ0NTgank3eXaUJ49vNJtiHdqtt3S39hmbSPUw@mail.gmail.com>
Subject: Re: [REGRESSION/PATCH] acpi: blacklist win8 OSI for ASUS Zenbok Prime UX31A
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Aaron Lu <aaron.lwe@gmail.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 7:11 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:

> It is already broken in v3.11-rc3, in fact I just booted that to try
> it out and it booted with the screen completely black (fortunately I
> knew exactly what to type to change that).
>
> Also, each time I change the
> backlight level from X, the screen blinks as if going 100%, 0%, and
> then the desired level.

This one is a bug in the ACPI driver. Here's the fix:

http://article.gmane.org/gmane.linux.kernel/1536959

Now instead of booting with 0% (off), it boots with 100%, which is
still not ideal, but way better.

-- 
Felipe Contreras
