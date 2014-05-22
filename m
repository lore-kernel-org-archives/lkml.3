Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaEVD5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 23:57:12 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:57785 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaEVD5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 23:57:10 -0400
Date: Wed, 21 May 2014 22:45:53 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Junio C Hamano <gitster@pobox.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Cc: git@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <537d72f16f11f_1bf76cb308f3@nysa.notmuch>
In-Reply-To: <xmqqa9abqczg.fsf@gitster.dls.corp.google.com>
References: <xmqqr43oq8q5.fsf@gitster.dls.corp.google.com>
 <537bf50f27417_353e13c330846@nysa.notmuch>
 <xmqqa9abqczg.fsf@gitster.dls.corp.google.com>
Subject: Re: [ANNOUNCE] Git v2.0.0-rc4
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano wrote:
> Felipe Contreras <felipe.contreras@gmail.com> writes:
> 
> > Junio C Hamano wrote:
> >
> >>  * The remote-helper interface to fast-import/fast-export via the
> >>    transport-helper has been tightened to avoid leaving the import
> >>    marks file from a failed/crashed run, as such a file that is out-of-
> >>    sync with reality confuses a later invocation of itself.
> >
> > Really? Where are the patches for that?
> >
> > I think it's fair to say the way the remote-helpers and transport-helper
> > has been handled for v2.0 has been a total disaster.
> 
> Thanks for noticing.  The last-minute change of plans in the morning
> on the -rc release day did not help.  Will remove.

But this changed before that.

> Anything else I missed?

Not as far as I can see.

-- 
Felipe Contreras
