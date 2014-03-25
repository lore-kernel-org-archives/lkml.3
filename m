Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbaCYRsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:48:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643AbaCYRsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:48:12 -0400
Date: Tue, 25 Mar 2014 18:46:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, gnomes@lxorguk.ukuu.org.uk, riel@redhat.com,
        snorcht@gmail.com, dhowells@redhat.com, luto@amacapital.net,
        daeseok.youn@gmail.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] Pre-emption control for userspace
Message-ID: <20140325174624.GA15527@redhat.com>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <1395767870-28053-1-git-send-email-khalid.aziz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395767870-28053-1-git-send-email-khalid.aziz@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25, Khalid Aziz wrote:
>
>  fs/proc/base.c                                     |  89 ++++++++

This code can be simplified, but the real question is why do we need it.

Just add PR_SET_PREEMPT_DELAY ?

Oleg.

