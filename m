Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaJSRTY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 13:19:24 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:36055 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaJSRTX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 13:19:23 -0400
MIME-Version: 1.0
In-Reply-To: <1413672385-8492-1-git-send-email-dg@emlix.com>
References: <1413672385-8492-1-git-send-email-dg@emlix.com>
Date: Sun, 19 Oct 2014 21:19:23 +0400
Message-ID: <CAMo8Bf+o6o489UQ0ss18MWAX80pM0yLwJdykAtXXTFRLmb8XnQ@mail.gmail.com>
Subject: Re: [PATCH] xtensa: remove s6000 variant and s6105 platform
From: Max Filippov <jcmvbkbc@gmail.com>
To: =?UTF-8?Q?Daniel_Gl=C3=B6ckner?= <dg@emlix.com>
Cc: Chris Zankel <chris@zankel.net>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 2:46 AM, Daniel Glöckner <dg@emlix.com> wrote:
> The Stretch s6000 family support has been merged into mainline 5 years
> ago. There appear to be no users of this code since nobody complained
> that there is a merge error preventing compilation.
>
> Apart from the s6105 IP camera reference design there are no s6000 devices
> known to ever have run Linux and as the chips are out of production there
> probably never will be. The successor s7000 no longer uses an Xtensa core
> for the OS.
>
> Let's remove the code until someone is found who actually needs it.
>
> Signed-off-by: Daniel Glöckner <dg@emlix.com>

Applied to my fixes tree. Thanks!

-- Max
