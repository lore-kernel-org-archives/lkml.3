Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab3IJSaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 14:30:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42928 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab3IJSaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 14:30:14 -0400
Message-ID: <522F6519.4030004@zytor.com>
Date: Tue, 10 Sep 2013 11:29:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, David Lang <david@lang.hm>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>  <19562.1378747124@turing-police.cc.vt.edu>  <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>  <1378767723.17982.27.camel@x230.lan>  <alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>  <1378774394.17982.36.camel@x230.lan>  <alpine.DEB.2.02.1309091938420.1820@nftneq.ynat.uz>  <1378781715.17982.42.camel@x230.lan>  <alpine.DEB.2.02.1309092002060.1820@nftneq.ynat.uz>  <1378785208.17982.54.camel@x230.lan>  <20130910172318.GB21530@khazad-dum.debian.net> <1378837571.17615.0.camel@x230.lan>
In-Reply-To: <1378837571.17615.0.camel@x230.lan>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 11:26 AM, Matthew Garrett wrote:
> On Tue, 2013-09-10 at 14:23 -0300, Henrique de Moraes Holschuh wrote:
>> On Tue, 10 Sep 2013, Matthew Garrett wrote:
>>> That's why modern systems require signed firmware updates.
>>
>> Linux doesn't.  Is someone working on adding signature support to the
>> runtime firmware loader?
> 
> It'd be simple to do so, but so far the model appears to be that devices
> that expect signed firmware enforce that themselves.
> 

Most devices do absolutely no verification on the firmware, and simply
trust the driver.

So signing firmware is probably critical.

	-hpa

