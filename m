Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab3JMItp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 04:49:45 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:45759 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab3JMItn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 04:49:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAHR064ge8zew7uMeD+_LXR3ju5ARGG1y8utLOFzOLexny_DPLA@mail.gmail.com>
References: <1381236524-19633-1-git-send-email-felipe.contreras@gmail.com>
	<CAHR064ge8zew7uMeD+_LXR3ju5ARGG1y8utLOFzOLexny_DPLA@mail.gmail.com>
Date: Sun, 13 Oct 2013 03:49:41 -0500
Message-ID: <CAMP44s3KVJwTwpxG14k22Q47UXGYFHLQ9ZmWcEdHWiUkbahoaA@mail.gmail.com>
Subject: Re: [PATCH v2] platform: x86: asus-wmi: add fan control
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        acpi4asus-user <acpi4asus-user@lists.sourceforge.net>,
        Linux PM <linux-pm@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 10:59 AM, Corentin Chary
<corentin.chary@gmail.com> wrote:
>
>
>
> On Tue, Oct 8, 2013 at 1:48 PM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>>
>> Simple driver to enable control of the fan in ASUS laptops. So far this
>> has only been tested in ASUS Zenbook Prime UX31A, but according to some
>> online reference [1], it should work in other models as well.
>>
>> The implementation is very straight-forward, the only caveat is that the
>> fan speed needs to be saved after it has been manually changed because
>> it won't be reported properly until it goes back to 'auto' mode.
>
> This doesn't really seems to be related to wmi, and is likely to be
> available only on a subset of models. Maybe it should a separate driver
> instead ?

The first patch I sent was standalone, and you said it should be wmi,
and now I do it wmi, and you said it should be separate. Which is it?

-- 
Felipe Contreras
