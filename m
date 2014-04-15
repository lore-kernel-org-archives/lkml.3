Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbaDOPK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:10:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44937 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbaDOPK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:10:57 -0400
Date: Tue, 15 Apr 2014 16:10:49 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Emmanuel Colbus <ecolbus@manux.info>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][7/11][MANUX] Kernel compatibility : capset(2)
Message-ID: <20140415161049.721f44c1@alan.etchedpixels.co.uk>
In-Reply-To: <534D3769.9070309@manux.info>
References: <534D3769.9070309@manux.info>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, for your information, I decided to use 64-bit capabilities, in
> order to give a possibility to reduce the rights of an unprivileged
> software (for example, if a process lacks CAP_USR_CHMOD, it won't be
> able to perform a chmod on an existing file). This means I'm not using
> the same data structure as you; do you have any objection to it?

Save yourself the effort. The Linux old style capble() model is basically
broken. It's vaguely useful if you combine it with SELinux to repair some
of the awkward cases.

The world has moved on to MAC/DAC and is heading now for real
"capability" based security which is nothing to do with having a bunch of
bit flags.

Alan
