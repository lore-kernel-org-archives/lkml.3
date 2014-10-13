Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaJMMW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:22:57 -0400
Received: from pindarots.xs4all.nl ([82.161.210.87]:49154 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbaJMMWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:22:54 -0400
Message-ID: <543BC419.2030209@xs4all.nl>
Date: Mon, 13 Oct 2014 14:22:49 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: CRASH during boot 3.16.3+
References: <543A88E4.4060707@xs4all.nl> <543ABD7D.5010308@hurleysoftware.com> <543BA610.8010001@xs4all.nl> <543BC242.7020304@hurleysoftware.com>
In-Reply-To: <543BC242.7020304@hurleysoftware.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-13 14:14, Peter Hurley wrote:
>> Incomplete dmesg attached for 3.16.2.
> 
> Why incomplete? No kernel command line, no version stamp, no CPU info,
> no memory map, no IRQ routing info, etc.

Because the buffer is filled with other stuff and scrolls out.

>>> And rubbish is not
>> very descriptive. Please include a sample, if you can't catch all the
>> console prints.

It all scrolls quickly.
When things start to go wrong:
First I see some register dumps that look like normal console output.
After that the stream of text changes into stuff not intended for human
consumption.


Udo
