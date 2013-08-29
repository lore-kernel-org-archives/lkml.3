Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab3H2PCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 11:02:20 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:60543 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab3H2PCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 11:02:18 -0400
From: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
To: Chris Rodley <chris@snapithd.com>
Cc: kernel@savoirfairelinux.com, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: sht15 kernel driver
References: <521E7CA7.5060407@snapithd.com> <87fvtt4dmt.fsf@jerows.sfl>
	<521EBD9F.7070502@snapithd.com>
Date: Thu, 29 Aug 2013 11:02:16 -0400
In-Reply-To: <521EBD9F.7070502@snapithd.com> (Chris Rodley's message of "Thu,
	29 Aug 2013 15:18:55 +1200")
Message-ID: <87ppswh75z.fsf@jerows.sfl>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Rodley <chris@snapithd.com> writes:

> Thanks Jerome!
>
> That was just what I needed to know.
> The device is now set up and is working well - I will have a go at
> back porting now.
>
> Many thanks again for your help!
> Chris

Good to know Chris!

Note, we noticed that the sht15 driver may be sensible to noisy lines,
we suspect a race condition around the interrupt handling code.

If your sensor is populated on the board you shouldn't have problems
though.

Jerome
