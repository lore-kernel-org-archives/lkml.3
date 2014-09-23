Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaIWLvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:51:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbaIWLvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:51:13 -0400
Message-ID: <54215E7B.4050002@redhat.com>
Date: Tue, 23 Sep 2014 07:50:19 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] signal: document the RCU protection of ->sighand
References: <20140922164440.GA28942@redhat.com>
In-Reply-To: <20140922164440.GA28942@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 09/22/2014 12:44 PM, Oleg Nesterov wrote:
> __cleanup_sighand() frees sighand without RCU grace period. This
> is correct but this looks "obviously buggy" and constantly confuses
> the readers, add the comments to explain how this works.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUIV57AAoJEM553pKExN6DknIH/0uxa6E8h0hOHE3qSU6EGxXp
0MF7cKifnaaV/tI+4w7MY1afknMjgiuSRoSZnw+1aTCkxhQKVfxboOt4cOrs/kQ5
pgBwCYvYGEtFS40XAmeZ7emxh7jZXpM7yGEzjsfCNZfPqWf78OBYiV093aix3gPj
lkUiKp+Lociux7PbOw+ADkvu4VE7PuhKt/Ya4JLJcxr+TODazeyuwfch/Id2Sc4y
GhMm34+poJE8e3go3LrsIOr8BIffyyXxRVCrZVMduLuH+/oFGZa3D/eKZX/hLX8L
WXAaf4/xNlPDHYuSoQX5pjTPAgua11DJQ0kW35zJ3EubXWdNfTLUGVhNVQgw7h0=
=h5ZA
-----END PGP SIGNATURE-----
