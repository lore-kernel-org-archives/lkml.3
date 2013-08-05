Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab3HEK5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 06:57:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35562 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab3HEK5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 06:57:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Kamal Mostafa <kamal.mostafa@canonical.com>, dmitry.torokhov@gmail.com,
        rydberg@euromail.se, kendatsuba@gmail.com, linux-input@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kernel Team <kernel-team@lists.ubuntu.com>
Subject: Re: [PATCH][v3.2.y][v3.5.y][3.8.y] Input: elantech - fix for newer hardware versions (v7)
References: <51E9B4A1.3080205@canonical.com>
Date: Mon, 05 Aug 2013 11:57:40 +0100
In-Reply-To: <51E9B4A1.3080205@canonical.com> (Joseph Salisbury's message of
	"Fri, 19 Jul 2013 17:50:25 -0400")
Message-ID: <87bo5cjtgb.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joseph Salisbury <joseph.salisbury@canonical.com> writes:

> Hello,
>
> Please consider including upstream commit
> 9eebed7de660c0b5ab129a9de4f89d20b60de68c in the next v3.2.y, v3.5.y and
> v3.8.y releases. 
>
> It was included upstream as of v3.11-rc1.  It has been tested and
> confirmed to resolve http://bugs.launchpad.net/bugs/1166442 .
>
> commit 9eebed7de660c0b5ab129a9de4f89d20b60de68c
> Author: Matteo Delfino <kendatsuba@gmail.com>
> Date:   Sat Jul 6 21:52:26 2013 -0700
>
>     Input: elantech - fix for newer hardware versions (v7)
>
>
> Sincerely,
> Joseph Salisbury
>
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks, I'm queuing it for the 3.5 kernel.

Cheers,
-- 
Luis
