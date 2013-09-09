Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3IITmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 15:42:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60561 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab3IITmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 15:42:38 -0400
Message-ID: <522E2487.90109@zytor.com>
Date: Mon, 09 Sep 2013 12:41:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: David Lang <david@lang.hm>, Matthew Garrett <matthew.garrett@nebula.com>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        gregkh@linuxfoundation.org, linux-efi@vger.kernel.org,
        jmorris@namei.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com> <19562.1378747124@turing-police.cc.vt.edu>            <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz> <27562.1378753264@turing-police.cc.vt.edu>
In-Reply-To: <27562.1378753264@turing-police.cc.vt.edu>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 12:01 PM, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 09 Sep 2013 11:25:38 -0700, David Lang said:
> 
>> Given that we know that people want signed binaries without
>> blocking kexec, you should have '1' just enforce module signing
>> and '2' (or higher) implement a full lockdown including kexec.
> 
>> Or, eliminate the -1  permanently insecure option and make this a
>> bitmask, if someone wants to enable every possible lockdown, have
>> them set it to "all 1's", define the bits only as you need them.
> 
> This strikes me as much more workable than one big sledgehammer.
> 

I.e. capabilities ;)

	-hpa

