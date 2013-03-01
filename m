Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab3CABao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 20:30:44 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:34732 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3CABan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 20:30:43 -0500
MIME-Version: 1.0
In-Reply-To: <CAJd=RBBtCxBgoeJ8xcj4zqv7pEk7uAy39V=in4RppDH05GjPkA@mail.gmail.com>
References: <512B677D.1040501@oracle.com> <CAHGf_=rur29gFs9R9AYeDwnbVBm3b3cOfAn2xyi=mQ+ZbgzEDA@mail.gmail.com>
 <512C15F0.6030907@oracle.com> <CAJd=RBBxTutPsF+XPZGt44eT1f0uPAQfCvQj_UmwdDg82J=F+A@mail.gmail.com>
 <CAHGf_=r5oo+N0_BSd-8-GPeburBnHVAjLEszmNkj+ASMJXqYLQ@mail.gmail.com> <CAJd=RBBtCxBgoeJ8xcj4zqv7pEk7uAy39V=in4RppDH05GjPkA@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 28 Feb 2013 20:30:22 -0500
X-Google-Sender-Auth: R1eeV5EKbBFgsoNfhhrS_pep9lY
Message-ID: <CAHGf_=pFebzif0CZs1bt0kXE+F9Y79pO8XWe0VLnAO4iTbPrcA@mail.gmail.com>
Subject: Re: mm: BUG in mempolicy's sp_insert
To: Hillf Danton <dhillf@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 1:53 AM, Hillf Danton <dhillf@gmail.com> wrote:
> On Thu, Feb 28, 2013 at 1:26 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
>>> Insert new node after updating node in tree.
>>
>> Thanks. you are right. I could reproduce and verified.
>
> Thank you too;) pleasure to do minor work for you.
>
> btw, how about your belly now? fully recovered?

Yup. I could learned US health care a bit. =)
