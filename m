Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaLaTHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 14:07:04 -0500
Received: from mail-oi0-f53.google.com ([209.85.218.53]:54843 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaLaTHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 14:07:01 -0500
MIME-Version: 1.0
In-Reply-To: <20141231190044.GB25819@t400>
References: <1420051376-31180-1-git-send-email-lstoakes@gmail.com>
	<20141231190044.GB25819@t400>
Date: Wed, 31 Dec 2014 19:07:01 +0000
Message-ID: <CAA5enKaHPBWvmQfDEkdG5T-ZMgq-qCD1arCDvUTBK4bQSmqTNg@mail.gmail.com>
Subject: Re: [PATCH 1/4] staging: rtl8192u: fix comments
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Konrad Zapalowicz <bergo.torino@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, gdonald@gmail.com,
        tapaswenipathak@gmail.com, yejiayily@gmail.com,
        mcgrof@do-not-panic.com, anarey@gmail.com,
        linux-kernel@vger.kernel.org, rmfrfs@gmail.com, joe@perches.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 December 2014 at 19:00, Konrad Zapalowicz <bergo.torino@gmail.com> wrote:
>
> You also fix the line length here which shall be the subject of a
> separate patch as this is not C99 comments related change.
>

Apologies - I missed this, will prepare a v2 with this separated out
into a different patch. Relatedly, the intent was to fix whitespace
issues rather than line length as I gather a specific line length
limit is still a matter of debate in kernel style? I didn't want to
create additional noise by attempting to address that as well.

Best, Lorenzo
