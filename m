Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3IJXzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 19:55:36 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48329 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3IJXze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 19:55:34 -0400
Message-ID: <1378857327.2257.214.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Lang <david@lang.hm>, Kees Cook <keescook@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        Elena Reshetova <elena.reshetova@intel.com>
Date: Tue, 10 Sep 2013 19:55:27 -0400
In-Reply-To: <522FAFC4.5090503@zytor.com>
References: <1378767723.17982.27.camel@x230.lan>
	 <alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>
	 <1378774394.17982.36.camel@x230.lan>
	 <alpine.DEB.2.02.1309091938420.1820@nftneq.ynat.uz>
	 <1378781715.17982.42.camel@x230.lan>
	 <alpine.DEB.2.02.1309092002060.1820@nftneq.ynat.uz>
	 <1378785208.17982.54.camel@x230.lan>
	 <20130910172318.GB21530@khazad-dum.debian.net>
	 <1378837571.17615.0.camel@x230.lan> <522F6519.4030004@zytor.com>
	 <20130910185149.GC5559@kroah.com>
	 <CAGXu5j+3oKC-tQe8z43bG8wTpURD4FFCi+A1t9mSN_Bfzh8e8Q@mail.gmail.com>
	 <alpine.DEB.2.02.1309101217150.10412@nftneq.ynat.uz>
	 <522F768F.1000101@zytor.com>
	 <1378856601.2257.208.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <522FAFC4.5090503@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091023-6688-0000-0000-000001904CF0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-10 at 16:48 -0700, H. Peter Anvin wrote:
> On 09/10/2013 04:43 PM, Mimi Zohar wrote:
> > 
> > Why invent yet another method of verifying the integrity of a file based
> > on a signature?  Why not use the existing method for appraising files?
> > Just create a new integrity hook at the appropriate place.
> > 
> 
> What would the deliverables be from the hardware vendor and what tools
> would you expect them to need on their end?

The package installer needs to not only install files, but file metadata
as well.  Elena Reshetova (Intel) has already added rpm hooks to write
security xattrs.  The next step, yet to be done, is to include and write
the signatures as part of the rpm install process.

Mimi

