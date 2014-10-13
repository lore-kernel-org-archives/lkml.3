Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaJMOB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:01:56 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:42211 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751746AbaJMOBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:01:51 -0400
Message-ID: <543BDB4B.7020508@hurleysoftware.com>
Date: Mon, 13 Oct 2014 10:01:47 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: CRASH during boot 3.16.3+
References: <543A88E4.4060707@xs4all.nl> <543ABD7D.5010308@hurleysoftware.com> <543BA610.8010001@xs4all.nl> <543BC242.7020304@hurleysoftware.com> <543BC419.2030209@xs4all.nl>
In-Reply-To: <543BC419.2030209@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2014 08:22 AM, Udo van den Heuvel wrote:
> On 2014-10-13 14:14, Peter Hurley wrote:
>>> Incomplete dmesg attached for 3.16.2.
>>
>> Why incomplete? No kernel command line, no version stamp, no CPU info,
>> no memory map, no IRQ routing info, etc.
> 
> Because the buffer is filled with other stuff and scrolls out.

dmesg > log

>>>> And rubbish is not
>>> very descriptive. Please include a sample, if you can't catch all the
>>> console prints.
> 
> It all scrolls quickly.
> When things start to go wrong:
> First I see some register dumps that look like normal console output.
> After that the stream of text changes into stuff not intended for human
> consumption.

Ok.

