Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab3IIUQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 16:16:04 -0400
Received: from mail.lang.hm ([64.81.33.126]:36007 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab3IIUQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 16:16:01 -0400
Date: Mon, 9 Sep 2013 13:15:55 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <matthew.garrett@nebula.com>
cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
In-Reply-To: <1378757201.17982.20.camel@x230.lan>
Message-ID: <alpine.DEB.2.02.1309091311040.2479@nftneq.ynat.uz>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>  <19562.1378747124@turing-police.cc.vt.edu>  <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>  <1378751318.17982.10.camel@x230.lan>  <alpine.DEB.2.02.1309091139490.2479@nftneq.ynat.uz>
  <1378752158.17982.15.camel@x230.lan>  <alpine.DEB.2.02.1309091150570.2479@nftneq.ynat.uz>  <1378753619.17982.16.camel@x230.lan>  <alpine.DEB.2.02.1309091247340.2479@nftneq.ynat.uz> <1378757201.17982.20.camel@x230.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013, Matthew Garrett wrote:

> On Mon, 2013-09-09 at 12:59 -0700, David Lang wrote:
>
>> At least you should be able to unify the implementation, even if you don't unify
>> the user visible knob
>
> Well sure, I could take this integer and merge another integer into it,
> but now you have the same value being modified by two different
> user-visible interfaces which aren't guaranteed to have the same
> semantics.

It's not that you merge integers, it's that the knob that currently sets the 
signed module only loading but not anything else would have it's implementation 
changed so that instead of doing whatever it currently does, it would instead 
make an internal call to set the "require signed modules" bit, and that one 
place would implement the lockdown.

David Lang
