Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaENVjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:39:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60900 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbaENVji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:39:38 -0400
Message-ID: <5373E286.2080104@zytor.com>
Date: Wed, 14 May 2014 14:39:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Ley Foon Tan <lftan@altera.com>
CC: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH 04/25] avr32: Add 32 bit time_t and clock_t
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <1399971769-4116-1-git-send-email-lftan@altera.com> <20140513201944.GA14023@samfundet.no> <CAFiDJ5_5ret2H-OynLMhBStzyDDBLpF6Tsy4bbEUX+mKu2V4uA@mail.gmail.com> <20140514074456.GB17409@samfundet.no>
In-Reply-To: <20140514074456.GB17409@samfundet.no>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 12:44 AM, Hans-Christian Egtvedt wrote:
>> In this patchset, the generic one will be 64 bit (long long). So, the
>> existing 32 bit users need to override this.
> 
> Would it be wrong to use the architecture defined size, or does some 32-bit
> architectures use 64-bit time types?

This is what we had done up until now, except for x32, *AND THAT IS
EXACTLY THE PROBLEM*.  2038 is only 24 years away.

	-hpa


