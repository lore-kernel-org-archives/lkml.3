Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab3EHXmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 19:42:12 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:47462 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab3EHXmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 19:42:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAH3drwZym3+o2cUhB37Zi6ALj65Z7j+N1w9WA-t1+0xi7XjWaw@mail.gmail.com>
References: <1367967522-3934-1-git-send-email-j.glisse@gmail.com>
 <CAHGf_=ofADKRCgDN5Tanx4PyvoJFF9r=cHYMd+VRc=N3=4FGuA@mail.gmail.com>
 <CAH3drwbt_YX-jWrwsp0X2CH3t9ms65fX40cvumr4FyRhKBcbyw@mail.gmail.com>
 <CAHGf_=rFd7xktoom2kg_1QgoCrqsVwdo2gzVR6UDzvm53ngjgw@mail.gmail.com> <CAH3drwZym3+o2cUhB37Zi6ALj65Z7j+N1w9WA-t1+0xi7XjWaw@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 8 May 2013 19:41:48 -0400
Message-ID: <CAHGf_=pV5suTybY50EH+73TqFW9cLqBYmA_Xzz5Bs0pZhYGD1A@mail.gmail.com>
Subject: Re: [PATCH] mm: honor FOLL_GET flag in follow_hugetlb_page v2
To: Jerome Glisse <j.glisse@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jerome Glisse <jglisse@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Why? The following bug_on inhibit both case.
>
> Yes i get lost on the double negation, but still my patch is correct
> and i am not using gup but follow_hugetlb_page directly and i run into
> the issue. My patch does not change the behavior for current user,
> just fix assumption new user might have when not setting the FOLL_GET
> flags.

I have no idea. I haven't seen your new use case.
