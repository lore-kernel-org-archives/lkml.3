Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbaEASgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:36:19 -0400
Received: from smtprelay02.ispgateway.de ([80.67.29.24]:33588 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaEASgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:36:18 -0400
References: <1398561815-22033-1-git-send-email-peter@piie.net> <1398763077-5542-1-git-send-email-peter@piie.net>
Message-ID: <cone.1398969373.839141.7919.1000@galar>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Andreas Mohr <andi@lisas.de>,
        Borislav Petkov <bp@suse.de>, Zhang Rui <rui.zhang@intel.com>,
        Javi Merino <javi.merino@arm.com>
Subject: Re: [PATCH v2 0/4] acerhdf/thermal: adding new models and
         appropriate governor
Date: Thu, 01 May 2014 20:36:13 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Peter Feuerer writes:
> This patch series is intended to:
> 
>   * Introduce "manual mode" support (Patch 1 & 2), which is needed to control
>     the fan of a few new models.
> 
>   * Add an appropriate thermal governor (Patch 3 & 4).  Manipulating and
>     fiddling around with the step-wise governor has been a very fragile thing
>     in the past and as it broke again, I used the opportunity to add a two
>     point thermal governor which implements the actual fan handling required by
>     acerhdf and puts from my point of view things straight.
> 
> Please test/review the patches and send me your comments.

Further comments on the patch series?  Otherwise I'll create another series 
containing the improvement to Javi's finding and we could get it committed?

@Rui: what do you think about the bang bang governor?

[...]


-- 
kind regards,
--peter;
