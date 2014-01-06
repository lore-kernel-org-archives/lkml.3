Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654AbaAFXSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:18:55 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58749 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932989AbaAFXSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 18:18:44 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PNPBIOS: check return value of pnp_add_device()
Date: Tue, 07 Jan 2014 00:32:30 +0100
Message-ID: <3555521.XezuyqRU3a@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140106223501.GB17357@core.coreip.homeip.net>
References: <20131215121102.GA509@core.coreip.homeip.net> <20140106223501.GB17357@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

I've just queued up your patch for 3.14 (the other one has already been in
my tree for a while).

Thanks,
Rafael

