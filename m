Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab3BYL5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 06:57:39 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:37116 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3BYL5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 06:57:37 -0500
MIME-Version: 1.0
In-Reply-To: <20121231014513.GA2416@khazad-dum.debian.net>
References: <CAD77+gROUfVX=9LPZc6_jf=2Bc_iaf5FW5Z2efwESzORNrq9dQ@mail.gmail.com>
 <1356817910-20890-1-git-send-email-richih.mailinglist@gmail.com>
 <20121230020008.GA24121@khazad-dum.debian.net> <CAD77+gROHKXOBDAy8A4sLnzSnZXTz-KKomk4nqrEfapjNo03vA@mail.gmail.com>
 <20121231014513.GA2416@khazad-dum.debian.net>
From: Richard Hartmann <richih.mailinglist@gmail.com>
Date: Mon, 25 Feb 2013 12:57:17 +0100
Message-ID: <CAD77+gQ8Ob0rbT_n4YAYtSqPScLLeawY66+7m_yZn_OBVOmTeg@mail.gmail.com>
Subject: Re: [ibm-acpi-devel] [PATCH] drivers/platform/x86/thinkpad_acpi.c:
 Handle HKEY event 0x6040
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: ibm-acpi-devel@lists.sourceforge.net, ibm-acpi@hmh.eng.br,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2012 at 2:45 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:

> Usually the subsystem maintainer picks such simple patches and ACKs directly
> from the platform-driver-x86 list email, adds his signed-of-by, and
> eventually sends it to Linus.

Just so this does not get lost, neither Linus' tree nor [1] carry this
patch, yet. Is there anything more I can/should do?


> For this "obviously correct" single-code-line fix, we might even lucky
> out and it could make it to 3.8, depends on his judgment.

Sadly, no.


Thanks,
Richard

[1] git://cavan.codon.org.uk/platform-drivers-x86.git
