Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab3AaWNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:13:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44683 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab3AaWNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:13:10 -0500
Message-ID: <510AEC68.2040500@zytor.com>
Date: Thu, 31 Jan 2013 14:12:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Yinghai Lu <yinghai@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [RFC][PATCH] rip out x86_32 NUMA remapping code
References: <20130131005616.1C79F411@kernel.stglabs.ibm.com> <510AE763.6090907@zytor.com> <CAE9FiQVn6_QZi3fNQ-JHYiR-7jeDJ5hT0SyT_+zVvfOj=PzF3w@mail.gmail.com> <510AE92B.8020605@zytor.com> <CAE9FiQUCB3CDB9kB6ojYRLHHjxgoRqmNFrcjkH1RNHjSHUZ4uQ@mail.gmail.com> <510AEA20.8040407@zytor.com> <510AEBA9.8090804@linux.vnet.ibm.com>
In-Reply-To: <510AEBA9.8090804@linux.vnet.ibm.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 02:09 PM, Dave Hansen wrote:
> On 01/31/2013 02:03 PM, H. Peter Anvin wrote:
>> That is arch-independent code, and the tile architecture still uses it.
>>
>> Makes one wonder how much it will get tested going forward, especially
>> with the x86-32 implementation clearly lacking in that department.
> 
> Yeah, I left the tile one because it wasn't obvious how it was being
> used over there.  It _probably_ has the same bugs that x86 does.
> 
> I'll refresh the patch fixing some of the compile issues and resend.
> 

I already have fixup patches, I think.

	-hpa

