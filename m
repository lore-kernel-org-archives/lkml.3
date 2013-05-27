Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab3E0IEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 04:04:38 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:61906 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab3E0IEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 04:04:35 -0400
MIME-Version: 1.0
In-Reply-To: <1369640823167-656004.post@n7.nabble.com>
References: <1369640823167-656004.post@n7.nabble.com>
Date: Mon, 27 May 2013 10:04:33 +0200
Message-ID: <CAFLxGvzStmjTJ0vqWpWDN7wYMvF2RGEU4=xgmJuyrxEwOtY85w@mail.gmail.com>
Subject: Re: why do we need atomic_set_unchecked
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: johnspaul92 <johns@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 9:47 AM, johnspaul92 <johns@ti.com> wrote:
> When i tried to apply the GrSecurity patch on linux kernel 3.10 and there the
> patch actually modifies atomic_set to atomic_set_unchecked. When i checked
> the gcc patch to compile this code it just redefines atomic_set as
> atomic_set_unchecked. So what is the use of changing the function name.?? Am
> I missing something here(i.e have they given a new definition for this
> function anywhere else). And i would also like to know what this
> function(atomic_set_unchecked. I know about the atomic_set function)  is
> used for.

Isn't this a question for the grsecurity developers?

--
Thanks,
//richard
