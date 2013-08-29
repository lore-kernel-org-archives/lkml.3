Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab3H2V6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 17:58:17 -0400
Received: from server.geeky.co.nz ([103.6.28.146]:48651 "EHLO
	server.geeky.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab3H2V6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 17:58:16 -0400
Message-ID: <521FC3F2.5030504@snapithd.com>
Date: Fri, 30 Aug 2013 09:58:10 +1200
From: Chris Rodley <chris@snapithd.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
CC: kernel@savoirfairelinux.com, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: sht15 kernel driver
References: <521E7CA7.5060407@snapithd.com> <87fvtt4dmt.fsf@jerows.sfl> <521EBD9F.7070502@snapithd.com> <87ppswh75z.fsf@jerows.sfl>
In-Reply-To: <87ppswh75z.fsf@jerows.sfl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/08/13 03:02, Jerome Oufella wrote:
> Chris Rodley <chris@snapithd.com> writes:
>> Thanks Jerome!
>>
>> That was just what I needed to know.
>> The device is now set up and is working well - I will have a go at
>> back porting now.
>>
>> Many thanks again for your help!
>> Chris
> Good to know Chris!
>
> Note, we noticed that the sht15 driver may be sensible to noisy lines,
> we suspect a race condition around the interrupt handling code.
>
> If your sensor is populated on the board you shouldn't have problems
> though.
>
> Jerome

Hi,

We have it working really well .. not noticing any issues - so far at least.
It is being populated more or less directly on the board - just via a 
daughter board in the prototype phase.
So I might not see the same issues.

If we find anything I will submit it back to you.

Many thanks again for your advice!
Chris
