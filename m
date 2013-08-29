Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab3H2P2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 11:28:38 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58987 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab3H2P2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 11:28:36 -0400
Date: Thu, 29 Aug 2013 08:28:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
Cc: Chris Rodley <chris@snapithd.com>, kernel@savoirfairelinux.com,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] sht15 kernel driver
Message-ID: <20130829152831.GA25021@roeck-us.net>
References: <521E7CA7.5060407@snapithd.com>
 <87fvtt4dmt.fsf@jerows.sfl>
 <521EBD9F.7070502@snapithd.com>
 <87ppswh75z.fsf@jerows.sfl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppswh75z.fsf@jerows.sfl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 11:02:16AM -0400, Jerome Oufella wrote:
> Chris Rodley <chris@snapithd.com> writes:
> 
> > Thanks Jerome!
> >
> > That was just what I needed to know.
> > The device is now set up and is working well - I will have a go at
> > back porting now.
> >
> > Many thanks again for your help!
> > Chris
> 
> Good to know Chris!
> 
> Note, we noticed that the sht15 driver may be sensible to noisy lines,
> we suspect a race condition around the interrupt handling code.
> 
Any proposed fixes ?

Guenter

> If your sensor is populated on the board you shouldn't have problems
> though.
> 
> Jerome
> 
> _______________________________________________
> lm-sensors mailing list
> lm-sensors@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/lm-sensors
> 
