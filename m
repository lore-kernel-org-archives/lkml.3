Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958Ab3DYQe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 12:34:29 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:48900 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab3DYQe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 12:34:26 -0400
Message-ID: <51795B09.9040908@gmail.com>
Date: Thu, 25 Apr 2013 18:34:17 +0200
From: Milan Broz <gmazyland@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        util-linux@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux 2.23
References: <20130425110450.GF2244@x2.net.home> <m2haiuvj2o.fsf@firstfloor.org>
In-Reply-To: <m2haiuvj2o.fsf@firstfloor.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.4.2013 15:25, Andi Kleen wrote:
>> Util-linux 2.23 Release Notes
>> =============================
>>
>> The cryptoloop support in the commands mount(8) and losetup(8) has been
>> REMOVED. The encryption= mount option and -e,-E,--encryption losetup options
>> are no more supported.
> 
> That's crazy. You're taking away access to existing data.

Nope. You can use cryptsetup.

https://lkml.org/lkml/2012/11/2/162

Milan
