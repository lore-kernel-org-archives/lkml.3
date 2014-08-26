Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbaHZVZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:25:57 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:45475 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbaHZVZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:25:54 -0400
MIME-Version: 1.0
In-Reply-To: <53FCEDDA.4060906@opensource.altera.com>
References: <1407770293-27190-1-git-send-email-tthayer@opensource.altera.com>
	<1407770293-27190-3-git-send-email-tthayer@opensource.altera.com>
	<20140814184949.GC11558@amd.pavel.ucw.cz>
	<53FCD456.3050404@opensource.altera.com>
	<53FCEDDA.4060906@opensource.altera.com>
Date: Tue, 26 Aug 2014 16:25:52 -0500
Message-ID: <CADhT+wfHMb=DvXTwzEZdhGrAeihc5QTnTAccU9T-4tXrRZ5SkA@mail.gmail.com>
Subject: Re: [PATCHv10 2/2] arm: dts: Add Altera SDRAM EDAC bindings &
 devicetree entries.
From: Dinh Nguyen <dinh.linux@gmail.com>
To: Dinh Nguyen <dinguyen@opensource.altera.com>
Cc: Thor Thayer <tthayer@opensource.altera.com>, Pavel Machek <pavel@denx.de>,
        Rob Herring <robherring2@gmail.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, atull@opensource.altera.com,
        Alan Tull <delicious.quinoa@gmail.com>, dougthompson@xmission.com,
        Grant Likely <grant.likely@linaro.org>, bp@alien8.de,
        sameo@linux.intel.com, lee.jones@linaro.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux List <linux-kernel@vger.kernel.org>,
        Thor Thayer <tthayer.linux@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-edac@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 3:28 PM, Dinh Nguyen
<dinguyen@opensource.altera.com> wrote:
> On 08/26/2014 01:39 PM, Thor Thayer wrote:
>>
>> On 08/14/2014 01:49 PM, Pavel Machek wrote:
>>> On Mon 2014-08-11 10:18:13, tthayer@opensource.altera.com wrote:
>>>> From: Thor Thayer <tthayer@opensource.altera.com>
>>>>
>>>> Add the Altera SDRAM EDAC bindings and device tree changes to the
>>>> Altera SoC project.
>>>>
>>>> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
>>> Acked-by: Pavel Machek <pavel@denx.de>
>>>
>>>
>> Hi All,
>>
>> Any further comments or suggestions on this patch series? Thanks for the
>> review, Pavel!
>
> If Boris is okay with driver part and everyone else is OK with the DTS
> portion, then I can apply the DTS patch to my tree, and Boris take the
> driver patch into his tree?
>


Actually, I think I need to get an Ack-by from a DTS maintainer before
I can apply
this as it is introducing a new binding.

Sorry for the noise.

Dinh
