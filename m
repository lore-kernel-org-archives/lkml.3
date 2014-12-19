Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaLSWFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 17:05:23 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61824 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaLSWFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 17:05:22 -0500
MIME-Version: 1.0
In-Reply-To: <20141219205435.GA24499@redhat.com>
References: <20141218161230.GA6042@redhat.com>
	<20141219024549.GB1671@redhat.com>
	<CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com>
	<20141219035859.GA20022@redhat.com>
	<20141219040308.GB20022@redhat.com>
	<CA+55aFzg0WN1_SzRagwwEDGUkKou4t+-gBNMUd-W3KM7tC+-AA@mail.gmail.com>
	<20141219145528.GC13404@redhat.com>
	<CA+55aFychipT9e0DenUumsGJ-=9BUTOX-OmAmQ3azMCspUrUtw@mail.gmail.com>
	<CA+55aFyb6N47N2Jg75EmRxDTjFF2y_oy4dHNDeW_dyM4PUTDrA@mail.gmail.com>
	<CA+55aFzt_4Zrnek6381JFzm+3iV9d=JAeyx+=E9F8BeiWFb56g@mail.gmail.com>
	<20141219205435.GA24499@redhat.com>
Date: Fri, 19 Dec 2014 14:05:20 -0800
X-Google-Sender-Auth: R6VdNRbFBcVVTOzklaWSvwlP4vM
Message-ID: <CA+55aFyafdtY9ZxNHx2LNRyD2Krn9jgfhOji-8P5vebAzEbNiw@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 12:54 PM, Dave Jones <davej@redhat.com> wrote:
>
> Right now I'm doing Chris' idea of "turn debugging back on,
> and try without serial console".  Shall I try your suggestion
> on top of that ?

Might as well. I doubt it really will make any difference, but I also
don't think it will interact badly in any way, so..

                      Linus
