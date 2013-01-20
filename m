Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3ATMAL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 07:00:11 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:46898 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3ATMAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 07:00:09 -0500
Message-ID: <50FBDC3F.1090509@xs4all.nl>
Date: Sun, 20 Jan 2013 12:59:59 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
References: <50FBC7EF.6040207@xs4all.nl> <20130120103652.GB16800@pd.tnic> <50FBC994.8020409@xs4all.nl> <20130120111920.GL25591@8bytes.org> <50FBD413.1000406@xs4all.nl> <20130120114011.GN25591@8bytes.org> <20130120114828.GB16519@pd.tnic> <20130120115011.GC16519@pd.tnic>
In-Reply-To: <20130120115011.GC16519@pd.tnic>
X-Enigmail-Version: 1.5.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-20 12:50, Borislav Petkov wrote:
>> Right, Udo, you can try Gigabyte first.
> 
> Btw, you're running the latest BIOS from them, I assume?

Nope. But I am beyond their first released BIOS, I am running one of
their beta BIOSes. I am two beta updates behind current with F3g.
They list as description for BIOS F3k:

1.    Beta BIOS
2.    Modify option of APU and memory voltage
3.    Modify option of CPU PWM switch rate
4.    Modify memory compatibility
5.    Modify ET6 compatibility


Udo
