Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3C1XG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 19:06:57 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:39965 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab3C1XGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 19:06:55 -0400
Message-ID: <5154CD0C.60901@free-electrons.com>
Date: Fri, 29 Mar 2013 00:06:52 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: 8250_dw: add support for clk api
References: <1364387748-13015-1-git-send-email-maxime.ripard@free-electrons.com> <20130328230342.GA24556@kroah.com>
In-Reply-To: <20130328230342.GA24556@kroah.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Le 29/03/2013 00:03, Greg Kroah-Hartman a écrit :
> On Wed, Mar 27, 2013 at 01:35:48PM +0100, Maxime Ripard wrote:
>> From: Emilio López <emilio@elopez.com.ar>
>>
>> This commit implements support for using the clk api; this lets us use
>> the "clocks" property with device tree, instead of having to use
>> clock-frequency.
>>
>> Signed-off-by: Emilio López <emilio@elopez.com.ar>
>> ---
> 
> Why aren't you signing off on this patch as well?

Hmm, I forgot to do so, and no one pointed that one before. Sorry.

Do you want me to resend it with my SoB?

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
