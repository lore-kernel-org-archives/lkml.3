Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab3LTPGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 10:06:50 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:39904 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab3LTPGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 10:06:49 -0500
MIME-Version: 1.0
In-Reply-To: <1387547475-7135-2-git-send-email-michael.hoefler@studium.uni-erlangen.de>
References: <1387547475-7135-1-git-send-email-michael.hoefler@studium.uni-erlangen.de>
	<1387547475-7135-2-git-send-email-michael.hoefler@studium.uni-erlangen.de>
Date: Fri, 20 Dec 2013 20:36:48 +0530
Message-ID: <CADKvho6HF9A6agDXwrg7UPcOS0YQh3bPmGzPjOAEO8tZ8cveTw@mail.gmail.com>
Subject: Re: [PATCHv2 1/3] silicom: fix whitespace issues in bypass.c
From: Gokulnath A <gokul.linux@gmail.com>
To: Michael Hoefler <michael.hoefler@studium.uni-erlangen.de>
Cc: "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Kohl <christoph.kohl@t-online.de>,
        open list <linux-kernel@vger.kernel.org>,
        Rupert Muchembled <rupert@rmuch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michael,

On Fri, Dec 20, 2013 at 7:21 PM, Michael Hoefler
<michael.hoefler@studium.uni-erlangen.de> wrote:
> This patch addresses several problems in bypass.c found by checkpatch.
> Furthermore it removes/adds some empty lines to make the code more readable.
>
> The following problems are fixed:
>  - line over 80 characters
>  - space after logical operator !
>  - spaces instead of tabs
>  - missing empty line after local declarations
>  - empty line after {
>

Please do one thing per patch, As Greg suggested for me in previous mail
conversations. Here you could have at least 3 or 4 patches.
For example, first patch would be a fix for line over 80 characters,
followed by the other problems as mentioned above by you.

> The empty line issues were not discovered by checkpatch but in my opinion these
> changes make perfect sense in terms of readability.
>
> Signed-off-by: Michael Hoefler <michael.hoefler@studium.uni-erlangen.de>
> Signed-off-by: Christoph Kohl <christoph.kohl@t-online.de>
> ---
>  drivers/staging/silicom/bypasslib/bypass.c | 111 ++++++++++++++++-------------
>  1 file changed, 61 insertions(+), 50 deletions(-)
>
 1.8.1.2
>
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
