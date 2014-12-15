Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750875AbaLOU3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 15:29:42 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34794 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaLOU3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 15:29:40 -0500
Message-ID: <548F44B0.6020600@gmail.com>
Date: Mon, 15 Dec 2014 12:29:36 -0800
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: LKML <linux-kernel@vger.kernel.org>, Corey Minyard <cminyard@mvista.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH RFC] Docs: Modernize SubmittingPatches
References: <20141215105251.16913f8c@lwn.net>
In-Reply-To: <20141215105251.16913f8c@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014 7:52 AM, Jonathan Corbet wrote:
> The SubmittingPatches file still shows a lot of its roots from the era when
> we all sent stuff straight to Linus and hoped for the best.  I've gone in
> and thrashed it up to reflect an age where few of us type our own "diff"
> commands anymore.  Also added a section on preparing signed tags for pull
> requests.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> ---
>  Documentation/SubmittingPatches | 433 ++++++++++++++++++++--------------------
>  1 file changed, 212 insertions(+), 221 deletions(-)
> 
> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> index 1fa1caa198eb..787d0711e18a 100644
> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches
> @@ -10,27 +10,48 @@ kernel, the process can sometimes be daunting if you're not familiar
>  with "the system."  This text is a collection of suggestions which
>  can greatly increase the chances of your change being accepted.
>  
> -Read Documentation/SubmitChecklist for a list of items to check
> -before submitting code.  If you are submitting a driver, also read
> +This document contains a large number of suggestions in a relatively terse
> +format.  For detailed information on how the kernel development process
> +works, see Documentation/development-process.  Also, read
> +Documentation/SubmitChecklist for a list of items to check before
> +submitting code.  If you are submitting a driver, also read
>  Documentation/SubmittingDrivers.

If you are submitting a devicetree binding patch, also read
Documentation/devicetree/bindings/submitting-patches.txt.

< snip >

-Frank
