Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308Ab3B1F1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 00:27:05 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:45180 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab3B1F1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 00:27:01 -0500
MIME-Version: 1.0
In-Reply-To: <CAJd=RBBxTutPsF+XPZGt44eT1f0uPAQfCvQj_UmwdDg82J=F+A@mail.gmail.com>
References: <512B677D.1040501@oracle.com> <CAHGf_=rur29gFs9R9AYeDwnbVBm3b3cOfAn2xyi=mQ+ZbgzEDA@mail.gmail.com>
 <512C15F0.6030907@oracle.com> <CAJd=RBBxTutPsF+XPZGt44eT1f0uPAQfCvQj_UmwdDg82J=F+A@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 28 Feb 2013 00:26:39 -0500
X-Google-Sender-Auth: zDSkeEhqplyDRx7j5HTxcIDcnTs
Message-ID: <CAHGf_=r5oo+N0_BSd-8-GPeburBnHVAjLEszmNkj+ASMJXqYLQ@mail.gmail.com>
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

> Insert new node after updating node in tree.

Thanks. you are right. I could reproduce and verified.
