Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbaLNAHt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 19:07:49 -0500
Received: from senator.holtmann.net ([87.106.208.187]:51879 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaLNAHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 19:07:48 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: bluetooth: Add hci_h4p driver
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20141213235131.GA23566@amd>
Date: Sun, 14 Dec 2014 01:07:42 +0100
Cc: =?utf-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, khilman@kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        linux-bluetooth@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <ED6FB9B5-7BD5-4398-ACA4-C5D1547B91A4@holtmann.org>
References: <20141213223727.GA13894@amd> <570BAC61-3137-42E5-B4F8-A61AEED380DE@holtmann.org> <20141213235131.GA23566@amd>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

>>> My notes say that Marcel wanted different filenames, but I'd need
>>> advice exactly what filenames. I guess platform data supprort should
>>> be removed altogether, rather than renamed.
>> 
>> Yes, the platform support should go away. This should be purely based on DT.
>> 
>> Can you also start using git format-patch so that patches get a diffstat.
> 
> So the rest of filenames look ok?

I have not looked at the patch or the filenames at all.

Regards

Marcel


