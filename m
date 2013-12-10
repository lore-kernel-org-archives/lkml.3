Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab3LJTdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:33:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62320 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3LJTdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:33:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v4 0/9] ARM: Initial support for Marvell Berlin SoCs
Date: Tue, 10 Dec 2013 20:33:00 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1383661723-17956-1-git-send-email-sebastian.hesselbarth@gmail.com> <52A674F1.7000104@gmail.com> <20131210191653.GA10105@quad.lixom.net>
In-Reply-To: <20131210191653.GA10105@quad.lixom.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312102033.00953.arnd@arndb.de>
X-Provags-ID: V02:K0:RrYeDd+bEyH18vfkj2fGmOfH8/Aim5cqoJTHUJGrH+y
 1xhxGzcJzcTlgdrdQWLLFCO0OArFFkuDCm6828Ly9NFinAk21U
 T+kOipTFWES1Tlaa4W1lyeJLurrCuxfO7TFuZ7yMfdZhIuauWS
 2tyJTa7VjUJFa1VuoAcyDbxgCYM4FRlCFiW7Hy7oAaXDEO9JgP
 Ih42UOo8537y7rZlYneUvSxLbB7J32BGIDzbUKnYelJCycMCBM
 4arvpV9ClJaLWCHjK0qYmCNB7jpHNsRIOMRxTke3pWXGmLqrxM
 SluqU++TQ7pinE+Ui7t93oUeGqvGDy0wIBHDPJB4+MTSL4z78E
 foH8BnZE+D9LmYcYL/EE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 December 2013, Olof Johansson wrote:
> > I started with mach-mvebu in the first RFC, but Berlin SoCs are from a
> > different business unit at Marvell and are more PXA compatible than
> > Orion/Kirkwood/Armada 370/XP. Most notably, they lack the "mbus" and
> > IP is either from PXA/MMP or Synopsys DW. Thomas Petazzoni and also
> > Jisheng Zhang from Marvell suggested to not put it into mvebu but
> > have a different mach folder instead.
> 
> Hmm, ok. Well, maybe later on we can look at aggregating them more again. It'd
> be nice to get fewer top-level platform directories per vendor.

I possibly a lot of directories just become empty in the long run and
we remove them once all all code has been subsystemized and drivered.

	Arnd
