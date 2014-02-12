Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaBLAZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 19:25:55 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:50225 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbaBLAZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 19:25:54 -0500
Message-ID: <1392164751.19535.15.camel@x220>
Subject: Re: [PATCH] staging: r8188eu: default to "y" in Kconfig
From: Paul Bolle <pebolle@tiscali.nl>
To: Martin Walch <walch.martin@web.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Weinberger <richard@nod.at>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 12 Feb 2014 01:25:51 +0100
In-Reply-To: <10092086.3B4WUYQ8VT@tacticalops>
References: <1392121892.13064.9.camel@x220>
	 <10092086.3B4WUYQ8VT@tacticalops>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2014 00:25:52.0260 (UTC) FILETIME=[FC845440:01CF2788]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-12 at 01:09 +0100, Martin Walch wrote:
> On Tuesday 11 February 2014 13:31:32 Paul Bolle wrote:
> > This patch also deserves a
> >     Reported-by: Martin Walch <walch.martin@web.de>
> > 
> > line, but that apparently requires Martin's permission.
> 
> I would be happy.

It seems I interpreted the requirements for Reported-By: tags rather
strictly. We might change the documentation to discourage that
interpretation. (Greg, is it too late to add this tag in your queue?)

> And I am sorry for not sending patches myself. As I expect
> to find some more issues in Kconfig files soon, I wanted to gather all of
> them before sending any patches. However, I did not expect this to take me
> so long. Therefore I am glad you took the initiative and just created
> some patches.

My experience is that one can easily get stuck when trying to fix all
issues of a certain, broad category. Fixing all (say) all unused Kconfig
symbols is a big job. Fixing all that got added in v3.14-rc1 is doable
(depending on the amount of time one wants to spend).

Anyhow, I do hope you find time to send in patches yourself. Perhaps it
would help if we'd coordinate the stuff a bit. Richard seems keen to
help too.


Paul Bolle

