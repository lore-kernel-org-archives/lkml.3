Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab3CKRyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:54:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:36692 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab3CKRyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:54:14 -0400
Date: Mon, 11 Mar 2013 18:54:08 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Threaded irqs + 100% CPU RT task = RCU stall
Message-ID: <20130311175408.GC22286@linutronix.de>
References: <20130306154917.GA15249@windriver.com>
 <alpine.LFD.2.02.1303061651360.22263@ionos>
 <20130306171648.GO3268@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1303062010060.22263@ionos>
 <20130306214502.GC3268@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130306214502.GC3268@linux.vnet.ibm.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney | 2013-03-06 13:45:02 [-0800]:

>Is this behavior OK?  If so, the following (untested) patch might do
>what you want.  ;-)

Paul (Gortmaker) could you please test Paul's (McKenney) to see if it
makes things for Joe (Average) easier to spot?

Sebastian
