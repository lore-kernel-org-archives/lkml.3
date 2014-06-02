Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbaFBOF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:05:27 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:42870 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbaFBOFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:05:22 -0400
Message-ID: <538C849B.8080108@gmail.com>
Date: Mon, 02 Jun 2014 10:05:15 -0400
From: Kyle Evans <kvans32@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: toshiba_acpi: Unknown key 14b
References: <CA+MoWDqj33fEmsppxqSE4LSu9C40mam=UAouHweDBwTD_BMfpg@mail.gmail.com>
In-Reply-To: <CA+MoWDqj33fEmsppxqSE4LSu9C40mam=UAouHweDBwTD_BMfpg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What symbols go with the keys? Is it just one key, or two? I'm helping 
out another guy who has key 160 unknown and was planning on putting up a 
patch for that.

On 06/01/2014 06:02 AM, Peter Senna Tschudin wrote:
> Hi,
>
> I'm using:
>
> 3.15.0-rc7-next-20140530
>
> On a:
>
> Toshiba R830-10p
>
> And dmesg started to show:
>
> toshiba_acpi: Unknown key 14b
> toshiba_acpi: Unknown key 14d
>
> How can I help make this useful?
>
