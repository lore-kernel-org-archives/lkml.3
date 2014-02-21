Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbaBUGn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 01:43:59 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:43981 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbaBUGn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 01:43:57 -0500
MIME-Version: 1.0
Date: Fri, 21 Feb 2014 06:43:55 +0000
X-Google-Sender-Auth: TKBg_zm24IymEU8tyAPDRm8O15Q
Message-ID: <CAOMwXhP-e1wt+SnX8WuaxFRq2hZrnO4NLutzaa_ByuJ9J2a9FQ@mail.gmail.com>
Subject: OMAP138 (davinci) ecap driver support
From: Laszlo Papp <lpapp@kde.org>
To: avinashphilip@ti.com, thierry.reding@avionic-design.de
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we are currently having some implementation of it for an older kernel,
and I was just wondering if it is worth upstreaming, or the latest
linux kernel already has support for it, and we can drop our code
respectively?

I have seen the "./drivers/pwm/pwm-tiecap.c" file, but it seems to be
designed for AM33XX regardless its generic file name, and Kconfig
entry.

Cheers, L.
