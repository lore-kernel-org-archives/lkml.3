Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209Ab3BEF44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 00:56:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45884 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab3BEF4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 00:56:55 -0500
Message-ID: <51109F20.60205@zytor.com>
Date: Mon, 04 Feb 2013 21:56:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Priyaranjan Das <priyaranjan456789@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: ISO/IEC 7811 driver for Magnetic Cards.
References: <CAMNxYsyRRaHheOPBR18No4EFQ3=sedCmP85X-Hyg2bjapjtw+A@mail.gmail.com>
In-Reply-To: <CAMNxYsyRRaHheOPBR18No4EFQ3=sedCmP85X-Hyg2bjapjtw+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 09:08 PM, Priyaranjan Das wrote:
> Hi All,
>
> I am working on a Magnetic Card driver which would support ISO/IEC
> 7811 standard for track data. Can anyone tell me if such an
> implementation is available in existing kernel or not? I am basically
> looking for  code that implements the ISO/IEC 7811 standard or any
> similar standards.
>

You have to write a driver for whatever reader/writer you are using.  A 
lot of them simply show up as a USB HID (i.e. a keyboard) and thus don't 
need any driver at all.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

