Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3LCICo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:02:44 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:47913 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab3LCICl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:02:41 -0500
Date: Tue, 3 Dec 2013 09:02:32 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jingoo Han <jg1.han@samsung.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH 10/39] hwmon: remove DEFINE_PCI_DEVICE_TABLE macro
Message-ID: <20131203090232.7ba0e002@endymion.delvare>
In-Reply-To: <20131203001741.GA18237@roeck-us.net>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
	<001f01ceefb3$b1968820$14c39860$%han@samsung.com>
	<20131203001741.GA18237@roeck-us.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Dec 2013 16:17:41 -0800, Guenter Roeck wrote:
> On Tue, Dec 03, 2013 at 08:10:29AM +0900, Jingoo Han wrote:
> > Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> > is not preferred.
> > 
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> Acked-by: Guenter Roeck <linux@roeck-us.net>

Acked-by: Jean Delvare <khali@linux-fr.org>

too. I never liked this macro and I'm very happy to see it go.

-- 
Jean Delvare
