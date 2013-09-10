Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab3IJXtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 19:49:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45805 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab3IJXs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 19:48:59 -0400
Message-ID: <522FAFC4.5090503@zytor.com>
Date: Tue, 10 Sep 2013 16:48:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: David Lang <david@lang.hm>, Kees Cook <keescook@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
References: <1378767723.17982.27.camel@x230.lan>  <alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>  <1378774394.17982.36.camel@x230.lan>  <alpine.DEB.2.02.1309091938420.1820@nftneq.ynat.uz>  <1378781715.17982.42.camel@x230.lan>  <alpine.DEB.2.02.1309092002060.1820@nftneq.ynat.uz>  <1378785208.17982.54.camel@x230.lan>  <20130910172318.GB21530@khazad-dum.debian.net>  <1378837571.17615.0.camel@x230.lan> <522F6519.4030004@zytor.com>  <20130910185149.GC5559@kroah.com>  <CAGXu5j+3oKC-tQe8z43bG8wTpURD4FFCi+A1t9mSN_Bfzh8e8Q@mail.gmail.com>  <alpine.DEB.2.02.1309101217150.10412@nftneq.ynat.uz>  <522F768F.1000101@zytor.com> <1378856601.2257.208.camel@dhcp-9-2-203-236.watson.ibm.com>
In-Reply-To: <1378856601.2257.208.camel@dhcp-9-2-203-236.watson.ibm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 04:43 PM, Mimi Zohar wrote:
> 
> Why invent yet another method of verifying the integrity of a file based
> on a signature?  Why not use the existing method for appraising files?
> Just create a new integrity hook at the appropriate place.
> 

What would the deliverables be from the hardware vendor and what tools
would you expect them to need on their end?

	-hpa


