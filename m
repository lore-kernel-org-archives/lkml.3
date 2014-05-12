Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758441AbaELN0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 09:26:39 -0400
Received: from mout.gmx.net ([212.227.17.20]:62656 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758263AbaELN0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 09:26:36 -0400
MIME-Version: 1.0
Message-ID: <trinity-5cd78acf-a478-4ae4-8901-60ccf65a80f1-1399901181699@msvc024>
From: tbilles@gmx.com
To: "Hans de Goede" <hdegoede@redhat.com>, "Zhang Rui" <rui.zhang@intel.com>,
        "Len Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Aaron Lu" <aaron.lu@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Possible regression: sluggish inputs
Content-Type: text/plain; charset=UTF-8
Importance: normal
Date: Mon, 12 May 2014 15:26:21 +0200
X-Priority: 3
X-Provags-ID: V03:K0:+7FMg1mM6o2XUS7fQZNIP6MYjdjKeu/6bItCxVFT3O8
 /uDSWCMrf/MI+dDDTSMs+36Ehs5AO2GEMezmy8kWCRgF1jVixA
 nNwLSopxbU0DHbANWNOeaCf4b3lRa6SNqS/BNArBCdDDwEEugJ
 JNMNPI/bwIkhOIGgazB9PB9hf8YmCw4C0SuwjCiD2vLLFdzW46
 YxvRbDvxQiedf69oyzW/TlVosBB1a3eT4DAv9/DkyhdNaFmBNa
 JqFqNN9Fy3z43B+07qy9/JF9U//g5luceDNR/v0M6HJH7PEOf1 GyG4F0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, 03 May 2014 at 20:14:03, Hans de Goede wrote:
>On 05/03/2014 07:38 PM, tbilles@gmx.com wrote:
>> On Saturday, 03 May 2014 at 10:00:38, Hans de Goede wrote:
>>
>>> I've seen this happen occasionally on my E6430 both with and without
>>> the patch the bisect points too. I can trigger it by pressing
>>> brightness up / down as fast as I can. Likely the dimming on
>>> inactivity code is doing a much better job at sending brightness
>>> change commands as fast as possible, making it easier to trigger this.
>>> As for the commit you've bisected it too, it may be that that subtly
>>> changes things to make the problem easier to trigger, 
>> 
>> I don't have auto screen dimming enabled, but there could be something
>> else triggering it. Other than this, it all makes sense. The brightness
>> up / down buttons always act slowly for me. I can too trigger the sluggish
>> behaviour by pressing the brightness up or down buttons fast and
>> simultaneously moving the mouse. So yes, your patch is not the cause
>> of this, but for some reason it makes it easier to trigger. 
>> 
>>> but I distinctly remember having the same issue before I wrote that
>>> patch.
>> 
>> Let me try this 'your patch reverted on top of 3.14.2' kernel for a few
>> days to see if this behaviour shows up. Maybe I had it too, I just
>> didn't notice, because it was less frequent.

I didn't notice this behaviour since then, but I guess that doesn't prove
it's not there. 

I will continue using my 3.13.x kernel for the time being.

Thank you, Hans, for your time.

Tibor
