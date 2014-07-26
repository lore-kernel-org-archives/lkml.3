Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbaGZOQY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:16:24 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.100]:55556 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaGZOQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:16:23 -0400
References: <1398561815-22033-1-git-send-email-peter@piie.net> <1406043436-17068-1-git-send-email-peter@piie.net> <1406043436-17068-6-git-send-email-peter@piie.net>
Message-ID: <cone.1406384177.82717.7413.1000@galar>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Peter Feuerer <peter@piie.net>, Borislav Petkov <bp@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, Javi Merino <javi.merino@arm.com>
Subject: Re: [PATCH v5 5/6] acerhdf: added critical trip point
Date: Sat, 26 Jul 2014 16:16:17 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

Peter Feuerer writes:

> added critical trip point which represents the temperature limit.
> Added return -EINVAL in case wrong trip point is provided.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andreas Mohr <andi@lisas.de>
> Cc: Borislav Petkov <bp@suse.de>

Any concerns regarding this patch?

-- 
--peter;
