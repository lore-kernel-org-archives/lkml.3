Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab3HVAfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 20:35:12 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:62191 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab3HVAfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 20:35:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130821204901.GA19802@redhat.com>
References: <20130807055157.GA32278@redhat.com>
	<CAJd=RBCJv7=Qj6dPW2Ha=nq6JctnK3r7wYCAZTm=REVOZUNowg@mail.gmail.com>
	<20130807153030.GA25515@redhat.com>
	<CAJd=RBCyZU8PR7mbFUdKsWq3OH+5HccEWKMEH5u7GNHNy3esWg@mail.gmail.com>
	<20130819231836.GD14369@redhat.com>
	<CAJd=RBA-UZmSTxNX63Vni+UPZBHwP4tvzE_qp1ZaHBqcNG7Fcw@mail.gmail.com>
	<20130821204901.GA19802@redhat.com>
Date: Thu, 22 Aug 2013 08:35:10 +0800
Message-ID: <CAJd=RBC8ABbTwt476RcfhALqWdY+H8eva6bpDhYqv=Ggo9hXBg@mail.gmail.com>
Subject: Re: unused swap offset / bad page map.
From: Hillf Danton <dhillf@gmail.com>
To: Dave Jones <davej@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 4:49 AM, Dave Jones <davej@redhat.com> wrote:
>
> didn't hit the bug_on, but got a bunch of
>
> [  424.077993] swap_free: Unused swap offset entry 000187d5
> [  439.377194] swap_free: Unused swap offset entry 000187e7
> [  441.998411] swap_free: Unused swap offset entry 000187ee
> [  446.956551] swap_free: Unused swap offset entry 0000245f
>
Related to the regression reported?

Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with existing use
https://lkml.org/lkml/2013/8/21/294
