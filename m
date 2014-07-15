Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbaGOP3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:29:36 -0400
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:60796 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbaGOP3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:29:32 -0400
Message-ID: <ec017fca7d5ebeaa35b3bd94e494683f.squirrel@webmail.tu-dortmund.de>
In-Reply-To: <20140715115832.18997.90349.stgit@buzz>
References: <CALYGNiM9Fu9-i7hXMQNTUP69RfydN+2NqO29wZYd+4Gn25GbCQ@mail.gmail.com>
    <20140715115832.18997.90349.stgit@buzz>
Date: Tue, 15 Jul 2014 17:29:06 +0200
Subject: Re: [PATCH] mm: do not call do_fault_around for non-linear fault
From: "Ingo Korb" <ingo.korb@tu-dortmund.de>
To: "Konstantin Khlebnikov" <k.khlebnikov@samsung.com>
Cc: linux-mm@kvack.org, "Hugh Dickins" <hughd@google.com>,
        linux-kernel@vger.kernel.org, "Sasha Levin" <sasha.levin@oracle.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Dave Jones" <davej@redhat.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Ning Qu" <quning@google.com>,
        "Konstantin Khlebnikov" <koct9i@gmail.com>
User-Agent: SquirrelMail/1.4.23 [SVN]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Faulting around non-linear page-fault has no sense and
> breaks logic in do_fault_around because pgoff is shifted.

I can confirm that this patches fixes the bug here not just for the test
program but also the application where I originally noticed it.

-ik


