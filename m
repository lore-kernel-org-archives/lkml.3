Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaEBAw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 20:52:27 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:35350 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaEBAw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 20:52:26 -0400
MIME-Version: 1.0
In-Reply-To: <1398984278-29319-1-git-send-email-andi@firstfloor.org>
References: <1398984278-29319-1-git-send-email-andi@firstfloor.org>
Date: Thu, 1 May 2014 17:52:25 -0700
X-Google-Sender-Auth: RJLXTAm0XGv4rda-kp2ZL5sXrrM
Message-ID: <CA+55aFwc5znv-mqSX9nwVWNoXRUekoTiia4vgLgxauQcVZD15w@mail.gmail.com>
Subject: Re: Remove __visible from asmlinkage for 3.15
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 3:44 PM, Andi Kleen <andi@firstfloor.org> wrote:
> This is the earlier patchkit based on Linus original feedback.
> It should be merged for 3.15 to finally quell the asmlinkage warnings
> that are visible in various configurations.

Ack, looks good to me. I'm assuming I'll get this through the -tip
tree, otherwise holler and I'll pick it up directly, but it's not like
there is any major hurry.

              Linus
