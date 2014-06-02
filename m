Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbaFBPKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:10:10 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:37701 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbaFBPKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:10:04 -0400
MIME-Version: 1.0
In-Reply-To: <538C849B.8080108@gmail.com>
References: <CA+MoWDqj33fEmsppxqSE4LSu9C40mam=UAouHweDBwTD_BMfpg@mail.gmail.com>
	<538C849B.8080108@gmail.com>
Date: Mon, 2 Jun 2014 12:10:02 -0300
Message-ID: <CA+MoWDowBOec58arXQOXugVg_kSh3-q0TLWS7Tfup3m9yOMLTA@mail.gmail.com>
Subject: Re: toshiba_acpi: Unknown key 14b
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Kyle Evans <kvans32@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the noise. Those key code are produced when pressing fn +
arrow keys. It was a mistake, I wanted to press Windows key + arrows
to organize windows on gnome 3.

On Mon, Jun 2, 2014 at 11:05 AM, Kyle Evans <kvans32@gmail.com> wrote:
> What symbols go with the keys? Is it just one key, or two? I'm helping out
> another guy who has key 160 unknown and was planning on putting up a patch
> for that.
>
>
> On 06/01/2014 06:02 AM, Peter Senna Tschudin wrote:
>>
>> Hi,
>>
>> I'm using:
>>
>> 3.15.0-rc7-next-20140530
>>
>> On a:
>>
>> Toshiba R830-10p
>>
>> And dmesg started to show:
>>
>> toshiba_acpi: Unknown key 14b
>> toshiba_acpi: Unknown key 14d
>>
>> How can I help make this useful?
>>
>



-- 
Peter
