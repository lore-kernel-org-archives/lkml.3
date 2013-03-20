Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3CTGfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 02:35:20 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:38707 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3CTGfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 02:35:19 -0400
Message-ID: <5149589D.6090403@gmail.com>
Date: Wed, 20 Mar 2013 10:35:09 +0400
From: Lijo Antony <lijo.kernel@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Borislav Petkov <bp@alien8.de>, Ben Skeggs <bskeggs@redhat.com>,
        Lucas Stach <dev@lynxeye.de>, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@linux.ie>
Subject: Re: [Nouveau] nouveau lockdep splat
References: <20130304211608.GD22274@pd.tnic>  <1362501052.1933.2.camel@antimon> <20130319202432.GC4570@pd.tnic> <1363725620.3413.29.camel@thor.lan>
In-Reply-To: <1363725620.3413.29.camel@thor.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 12:40 AM, Peter Hurley wrote:
>>
>> with the hope of having the right people on CC now (finally, thanks
>> Lucas :-)), here's the same splat on -rc3. Someone better take a look
>> soonish, please:
>
> Also happens in next (on nv50 hardware).

I think this is same as https://lkml.org/lkml/2013/3/16/143 (btw, git 
bisect in that mail is incorrect). While investigating, I found this 
issue was introduced during 3.9 merge window. For me this comes when I 
connect my TV via HDMI. But for a couple of tags during bisecting, I 
have seen the same during boot also.

-lijo







