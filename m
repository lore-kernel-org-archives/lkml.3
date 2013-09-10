Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab3IJRX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:23:26 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54123 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502Ab3IJRXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:23:24 -0400
X-Sasl-enc: nS6WMfPhX2Q1U2sr6V8ia3hfVG420eV2spRKXDRdRnZo 1378833800
Date: Tue, 10 Sep 2013 14:23:18 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: David Lang <david@lang.hm>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
Message-ID: <20130910172318.GB21530@khazad-dum.debian.net>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
 <19562.1378747124@turing-police.cc.vt.edu>
 <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
 <1378767723.17982.27.camel@x230.lan>
 <alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>
 <1378774394.17982.36.camel@x230.lan>
 <alpine.DEB.2.02.1309091938420.1820@nftneq.ynat.uz>
 <1378781715.17982.42.camel@x230.lan>
 <alpine.DEB.2.02.1309092002060.1820@nftneq.ynat.uz>
 <1378785208.17982.54.camel@x230.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378785208.17982.54.camel@x230.lan>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, Matthew Garrett wrote:
> That's why modern systems require signed firmware updates.

Linux doesn't.  Is someone working on adding signature support to the
runtime firmware loader?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
