Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaLEToK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:44:10 -0500
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:40484 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233AbaLEToJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:44:09 -0500
Date: Fri, 5 Dec 2014 13:44:03 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Daney <ddaney.cavm@gmail.com>
cc: Kees Cook <keescook@chromium.org>,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Zubair.Kakakhel@imgtec.com, geert+renesas@glider.be,
        david.daney@cavium.com, Peter Zijlstra <peterz@infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, davidlohr@hp.com,
        "Maciej W. Rozycki" <macro@linux-mips.org>, chenhc@lemote.com,
        Ingo Molnar <mingo@kernel.org>, Richard Weinberger <richard@nod.at>,
        =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
        James Hogan <james.hogan@imgtec.com>, Tejun Heo <tj@kernel.org>,
        alex@alex-smith.me.uk, Paolo Bonzini <pbonzini@redhat.com>,
        John Crispin <blogic@openwrt.org>,
        Paul Burton <paul.burton@imgtec.com>, qais.yousef@imgtec.com,
        LKML <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Markos Chandras <markos.chandras@imgtec.com>, dengcheng.zhu@imgtec.com,
        manuel.lauss@gmail.com, lars.persson@axis.com
Subject: Re: [PATCH v3 3/3] MIPS: set stack/data protection as
 non-executable
In-Reply-To: <54820244.5010304@gmail.com>
Message-ID: <alpine.DEB.2.11.1412051343330.5206@gentwo.org>
References: <20141203015537.13886.50830.stgit@linux-yegoshin> <20141203015824.13886.74616.stgit@linux-yegoshin> <5481EB52.6060706@gmail.com> <CAGXu5jJJx0O7GhHghy+sC4fJL2O=RsO+Zgm78r9SNt-aTbhqcw@mail.gmail.com> <54820244.5010304@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2014, David Daney wrote:

> The problem is not with "modern" executables that are properly annotated with
> PT_GNU_STACK.
>
> My objection is to the intentional breaking of old executables that have no
> PT_GNU_STACK annotation, but require an executable stack.  Since we usually
> try not to break userspace, we cannot merge a patch like this one.

How old are these and how many are still around? Can the annotation be
added with a tool?

