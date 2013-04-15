Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934954Ab3DOTtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 15:49:19 -0400
Received: from www.sr71.net ([198.145.64.142]:53632 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934335Ab3DOTtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 15:49:17 -0400
Message-ID: <516C59BC.5050801@sr71.net>
Date: Mon, 15 Apr 2013 12:49:16 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, dhillf@gmail.com,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] kthread: Prevent unpark race which puts threads on the
 wrong cpu
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos> <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos> <alpine.LFD.2.02.1304091635430.21884@ionos> <51670C17.8070608@linux.vnet.ibm.com> <alpine.LFD.2.02.1304112158040.21884@ionos> <516728F6.4090701@linux.vnet.ibm.com> <alpine.LFD.2.02.1304112347390.21884@ionos>
In-Reply-To: <alpine.LFD.2.02.1304112347390.21884@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just tested out Linus's current tree (bb33db7).  It is quite happy on
the large system which was exciting this issue.  Thanks, Thomas!

