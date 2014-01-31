Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbaAaOrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:47:47 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:54836 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbaAaOrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:47:46 -0500
MIME-Version: 1.0
Reply-To: for.poige+linux@gmail.com
In-Reply-To: <CA+sTkh4fYZr-8vBuhA0c1BRt5D7oNiK=KrSF+kJ2KRW7e_LFaA@mail.gmail.com>
References: <CA+sTkh4fYZr-8vBuhA0c1BRt5D7oNiK=KrSF+kJ2KRW7e_LFaA@mail.gmail.com>
From: Igor Podlesny <for.poige+linux@gmail.com>
Date: Fri, 31 Jan 2014 22:47:09 +0800
X-Google-Sender-Auth: RI53g5wmmkmZU1KEnAQ3zjnaDhY
Message-ID: <CA+sTkh4p10P_BbxEx0vxS9uF0zA9G97K+4B_Q1Np55Ui83LVDQ@mail.gmail.com>
Subject: Re: That greedy Linux VM cache
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 January 2014 00:58, Igor Podlesny <for.poige+linux@gmail.com> wrote:
[...]
>  While I'm thinking about moving system back to XFS...

   Well, it helped just a bit. The whole picture remains, so it's not
Btrfs' issue, but seemingly Linux VM's one. The problem can be briefly
described as "if allowed to swap (swappiness != 0), VM would rather
start swapping, than reduce cache size which holds ~ 25 % of RAM".
Even more briefly it's stated in the Subject.

   From user's point of view, it looks like the system is being
heavily swapped (and can be easily misinterpreted as it), but actually
the most disk activity is permanent _reading_ from filesystem, and not
accessing swap device.

   Should I fill in a bug report in kernel's bugzilla, or just upgrade
the notebook? )

-- 
End of message. Next message?
