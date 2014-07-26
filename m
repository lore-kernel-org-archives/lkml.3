Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaGZOOx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:14:53 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:54215 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaGZOOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:14:51 -0400
References: <1398561815-22033-1-git-send-email-peter@piie.net> <1406043436-17068-1-git-send-email-peter@piie.net> <1406043436-17068-4-git-send-email-peter@piie.net>
Message-ID: <cone.1406384086.541895.7413.1000@galar>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Peter Feuerer <peter@piie.net>, Zhang Rui <rui.zhang@intel.com>,
        linux-pm@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, Borislav Petkov <bp@suse.de>,
        Javi Merino <javi.merino@arm.com>
Subject: Re: [PATCH v5 3/6] thermal: Added Bang-bang thermal governor
Date: Sat, 26 Jul 2014 16:14:46 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rui,

Peter Feuerer writes:

> The bang-bang thermal governor uses a hysteresis to switch abruptly on
> or off a cooling device.  It is intended to control fans, which can
> not be throttled but just switched on or off.
> Bang-bang cannot be set as default governor as it is intended for
> special devices only.  For those special devices the driver needs to
> explicitely request it.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Zhang Rui <rui.zhang@intel.com>

Anything that prevents you from giving your acked-by?

[...]

-- 
kind regards,
--peter;
