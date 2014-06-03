Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaFCNx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:53:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbaFCNx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:53:58 -0400
Message-ID: <1401803636.2274.6.camel@dmt>
Subject: Re: [PATCH] i8042: Don't print an error message just because
 there's no chip
From: Adam Jackson <ajax@redhat.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: linux-input@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Peter Jones <pjones@redhat.com>
Date: Tue, 03 Jun 2014 09:53:56 -0400
In-Reply-To: <CA+5PVA6zHH_rj_2cawnWxQ_JRiyybFsNM3d30cCN=FpMiMuXxg@mail.gmail.com>
References: <1222713404-1097-1-git-send-email-ajax@redhat.com>
	 <1393343227-13092-1-git-send-email-ajax@redhat.com>
	 <CA+5PVA6zHH_rj_2cawnWxQ_JRiyybFsNM3d30cCN=FpMiMuXxg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 11:06 -0500, Josh Boyer wrote:
> On Tue, Feb 25, 2014 at 10:47 AM, Adam Jackson <ajax@redhat.com> wrote:
> > From: Peter Jones <pjones@redhat.com>
> >
> > Some systems, such as EFI-based Apple systems, won't necessarily have an
> > i8042 to initialize. We shouldn't be printing an error message in this
> > case, since not detecting the chip is the correct behavior.
> >
> > v2: Downgrade to pr_notice instead of pr_err.
> >
> > Signed-off-by: Adam Jackson <ajax@redhat.com>
> 
> Reviewed-by:  Josh Boyer <jwboyer@fedoraproject.org>

Ping?  This patch or something like it has been pending since 2008 [1],
would be nice to see it merged before it's old enough to start first
grade.

[1] - https://lkml.org/lkml/2008/9/29/248

- ajax

