Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750770Ab3IFEyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 00:54:19 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:65083 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3IFEyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 00:54:17 -0400
MIME-Version: 1.0
In-Reply-To: <5229377E.5050805@hp.com>
References: <1378407316-59852-1-git-send-email-Waiman.Long@hp.com>
	<1378407316-59852-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFwShEG-bm2JuQJPF3DTq-O5CVdYXzwN5UpSckka0Wgm-A@mail.gmail.com>
	<5228E992.5050901@hp.com>
	<CA+55aFzx4YHY3e5AH0U5AkAQSc8pZyC35jBP4t2jpbi8NHM18g@mail.gmail.com>
	<5229377E.5050805@hp.com>
Date: Thu, 5 Sep 2013 21:54:16 -0700
X-Google-Sender-Auth: eh2rXSvQkbEj5Doh6XaWZVW_Maw
Message-ID: <CA+55aFydWW3Azfo_oh+M2MY75xJn+fd_pnKE-UBrEtw10jOhow@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 7:01 PM, Waiman Long <waiman.long@hp.com> wrote:
>
> I am sorry that I misunderstand what you said. I will do what you and Al
> advise me to do.

I'm sorry I shouted at you. I was getting a bit frustrated there..

            Linus
