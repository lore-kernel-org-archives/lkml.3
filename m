Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933941Ab3D3XSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 19:18:14 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:48089 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933786Ab3D3XSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 19:18:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130430222654.GA16716@havoc.gtf.org>
References: <20130430222654.GA16716@havoc.gtf.org>
Date: Tue, 30 Apr 2013 16:18:10 -0700
X-Google-Sender-Auth: b4kwjQTz5y_mvE9D-PGEk0BwcnU
Message-ID: <CA+55aFyGauCogyZojMp542kDJOMzumkjm3bR9iXP7=+4_aKs8g@mail.gmail.com>
Subject: Re: [git patches] libata updates
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 3:26 PM, Jeff Garzik <jeff@garzik.org> wrote:
>
> Summary:

return -EMISSINGDIFFSTAT;

I've pulled, but *please* make sure to fix your broken script. I
really do want to see the diffstat, partly because I want to know what
to expect even before pulling, partly just to verify that what I
pulled actually matches what you expected me to pull (iow, hopefully
you actually read your own diffstat and anything surprising would have
jumped out at you).

               Linus
