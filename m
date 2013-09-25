Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab3IYDOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 23:14:14 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:59926 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab3IYDOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 23:14:12 -0400
MIME-Version: 1.0
In-Reply-To: <52425041.6030609@gmail.com>
References: <52425041.6030609@gmail.com>
Date: Tue, 24 Sep 2013 20:14:11 -0700
X-Google-Sender-Auth: uWLha29NxZsmfKdjS2ZQii0G8w0
Message-ID: <CA+55aFxPHaTxixmmMZfKF-RzW4dfz=6o_1E5XR=GJ0qdSVNaxA@mail.gmail.com>
Subject: Re: [GIT PULL] Devicetree fixes for 3.12
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, Dinh Nguyen <dinguyen@altera.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 7:53 PM, Rob Herring <robherring2@gmail.com> wrote:
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git

Hmm. Did you mean for me to pull the "devicetree-fixes" tag?

If so, please say so very explicitly. I don't want to have to search
for these things..

IOW, if that's what you meant, that line should have said

  git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git
tags/devicetree-fixes

instead.

             Linus
