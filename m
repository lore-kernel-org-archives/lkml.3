Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaC1Vsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:48:38 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:35658 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbaC1Vsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:48:37 -0400
MIME-Version: 1.0
In-Reply-To: <1396042524.27583.0.camel@linux-builds1>
References: <1396041629-28820-1-git-send-email-robherring2@gmail.com>
	<1396042524.27583.0.camel@linux-builds1>
Date: Fri, 28 Mar 2014 16:48:36 -0500
Message-ID: <CAL_JsqLKti+1WCvt2kAMpic0u1zRtVJ-ZBvp2BasPx847ZDKLQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt/bindings: add binding for ARM Versatile character LCD
From: Rob Herring <robherring2@gmail.com>
To: Dinh Nguyen <dinguyen@altera.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 4:35 PM, Dinh Nguyen <dinguyen@altera.com> wrote:
> On Fri, 2014-03-28 at 16:20 -0500, Rob Herring wrote:
>> From: Rob Herring <robh@kernel.org>
>>
>> Add binding doc for Versatile platforms character LCD controller
>> interface.
>>
>> Signed-off-by: Rob Herring <robh@kernel.org>
>> Cc: Pawel Moll <pawel.moll@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>> Cc: Kumar Gala <galak@codeaurora.org>
>> ---
>>  Documentation/devicetree/bindings/misc/arm-charlcd.txt | 18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/misc/arm-charlcd.txt
>>
>> diff --git a/Documentation/devicetree/bindings/misc/arm-charlcd.txt b/Documentation/devicetree/bindings/misc/arm-charlcd.txt
>> new file mode 100644
>> index 0000000..e28e2aa
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/misc/arm-charlcd.txt
>> @@ -0,0 +1,18 @@
>> +ARM Versatile Character LCD
>> +-----------------------------------------------------
>> +This binding defines the character LCD interface found on ARM Versatile AB
>> +and PB reference platforms.
>> +
>> +Required properties:
>> +- compatible : "arm,versatile-clcd"
>
> Should this be "arm,versatile-lcd"?

Make up your mind. ;) -lcd is what is already used in the dts, but
since there was no driver support it should be okay to change the dts.
If we're changing, I think I'll change it to "arm,versatile-char-lcd".
'c' alone could just mean color.

Rob
