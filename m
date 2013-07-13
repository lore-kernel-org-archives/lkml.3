Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab3GMIF3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 04:05:29 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46903 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab3GMIFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 04:05:25 -0400
MIME-Version: 1.0
In-Reply-To: <20130713080153.GA5502@pd.tnic>
References: <1373701241-6499-1-git-send-email-alexj@rosedu.org> <20130713080153.GA5502@pd.tnic>
From: Alexandru Juncu <alexj@rosedu.org>
Date: Sat, 13 Jul 2013 11:05:04 +0300
X-Google-Sender-Auth: w0PIpH2CnGw9flxN9UizfkQ-GA8
Message-ID: <CAPhGq=b6FRJnjd+H_cxLLbs_cWR=p6WPdJtocV+je4=cCeRUmw@mail.gmail.com>
Subject: Re: [RFC] Script for isolating maintainer email.
To: Borislav Petkov <bp@alien8.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 July 2013 11:01, Borislav Petkov <bp@alien8.de> wrote:
> On Sat, Jul 13, 2013 at 10:40:41AM +0300, Alexandru Juncu wrote:
>> Hello!
>>
>> I found the need for a script that doesn't require me to copy part of the
>> output from get_maintainer.pl into git send-email and could do both with
>> one command.
>
> What's wrong with adding this to get_maintainer.pl itself? I.e.,
>
> git send-email --cc-cmd=./scripts/get_maintainer.pl my.patch ...


Nothing wrong at all. It's just that, to my shame, I don't know Perl.
