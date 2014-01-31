Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbaAaVqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:46:23 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:48844 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbaAaVqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:46:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAOesGMhFEMNFbAC4rUdccYVHM8yX9Mz+Vx73jGxBYGrSOa4Gaw@mail.gmail.com>
References: <1390685924-11877-1-git-send-email-marek@goldelico.com>
	<CAOesGMhFEMNFbAC4rUdccYVHM8yX9Mz+Vx73jGxBYGrSOa4Gaw@mail.gmail.com>
Date: Fri, 31 Jan 2014 22:46:17 +0100
Message-ID: <CAAfyv37SenewbPw9BeLyS_djbxdZf+3aizbgOhhOPNdbmUJrUg@mail.gmail.com>
Subject: Re: [PATCH] of: add vendor prefix for Honeywell
From: Belisko Marek <marek.belisko@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 7:53 PM, Olof Johansson <olof@lixom.net> wrote:
> On Sat, Jan 25, 2014 at 1:38 PM, Marek Belisko <marek@goldelico.com> wrote:
>> Signed-off-by: Marek Belisko <marek@goldelico.com>
>> ---
>>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
>> index 3f900cd..b14c617 100644
>> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
>> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
>> @@ -40,6 +40,7 @@ gmt   Global Mixed-mode Technology, Inc.
>>  gumstix        Gumstix, Inc.
>>  haoyu  Haoyu Microelectronic Co. Ltd.
>>  hisilicon      Hisilicon Limited.
>> +honeywell      Honeywell
>
> The norm has usually been to use the the stock ticker symbol of a
> public company if it is available. In other words, I think the prefix
> here should be 'hon', since Honeywell is a publicly traded company
> under that ticker.
OK I didn't know about that. I just pick name from here:
Documentation/devicetree/bindings/iio/magnetometer/hmc5843.txt
So we need to update also compatible property in mentioned file.
>
>
> -Olof

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
