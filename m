Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaLaT2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 14:28:41 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:42754 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaLaT2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 14:28:40 -0500
MIME-Version: 1.0
In-Reply-To: <20141231192301.GA3287@hudson.localdomain>
References: <1420051376-31180-1-git-send-email-lstoakes@gmail.com>
	<20141231192301.GA3287@hudson.localdomain>
Date: Wed, 31 Dec 2014 19:28:39 +0000
Message-ID: <CAA5enKbgi3To5BtTeT5nTjKxo9o_gkBF3mn3zAwtDbZEfycyDg@mail.gmail.com>
Subject: Re: [PATCH 1/4] staging: rtl8192u: fix comments
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Jeremiah Mahler <jmmahler@gmail.com>, Lorenzo Stoakes <lstoakes@gmail.com>,
        gregkh@linuxfoundation.org, anarey@gmail.com, mcgrof@do-not-panic.com,
        tapaswenipathak@gmail.com, joe@perches.com, rmfrfs@gmail.com,
        yejiayily@gmail.com, gdonald@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 December 2014 at 19:23, Jeremiah Mahler <jmmahler@gmail.com> wrote:
> But this change is not related to C99 comments and you didn't
> explain why this change was made in your log message.
> It should probably be in a separate patch.

Absolutely, I am currently fixing this and checking for any other
instances where unrelated changes may have crept in. Apologies for
this, a v2 of this patch set is coming shortly with this fixed.

Best, Lorenzo
