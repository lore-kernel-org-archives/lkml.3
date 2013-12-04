Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3LDAKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 19:10:14 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53585 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753139Ab3LDAKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 19:10:11 -0500
Message-ID: <1386115809.2166.126.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 11/41] parisc: Replace __get_cpu_var uses for address
 calculation
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Date: Tue, 03 Dec 2013 16:10:09 -0800
In-Reply-To: <20131203233250.717784556@linux.com>
References: <20131203233232.928771708@linux.com>
	 <20131203233250.717784556@linux.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-03 at 17:32 -0600, Christoph Lameter wrote:
> Convert to the use of this_cpu_ptr().
> 
> Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
> Cc: Helge Deller <deller@gmx.de>
> Cc: linux-parisc@vger.kernel.org

You say this in the commit, but the linux-parisc list isn't cc'd on the
email ...

James


