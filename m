Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab3IKJcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 05:32:21 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:53762 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab3IKJcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 05:32:19 -0400
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
From: joeyli <jlee@suse.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, David Lang <david@lang.hm>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
In-Reply-To: <1378837571.17615.0.camel@x230.lan>
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
	 <20130910172318.GB21530@khazad-dum.debian.net>
	 <1378837571.17615.0.camel@x230.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Sep 2013 17:32:52 +0800
Message-ID: <1378891972.6193.137.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 二，2013-09-10 於 18:26 +0000，Matthew Garrett 提到：
> On Tue, 2013-09-10 at 14:23 -0300, Henrique de Moraes Holschuh wrote:
> > On Tue, 10 Sep 2013, Matthew Garrett wrote:
> > > That's why modern systems require signed firmware updates.
> > 
> > Linux doesn't.  Is someone working on adding signature support to the
> > runtime firmware loader?
> 
> It'd be simple to do so, but so far the model appears to be that devices
> that expect signed firmware enforce that themselves.
> 
> -- 
> Matthew Garrett <matthew.garrett@nebula.com>
> NrybXǧv^)޺{.n+{y^nrzh&Gh(階ݢj"mzޖfh~m

Takashi has a implementation of firmware check:

[PATCH RFC v2 0/4] Add firmware signature file check
https://lkml.org/lkml/2012/11/8/343


Thanks
Joey Lee


