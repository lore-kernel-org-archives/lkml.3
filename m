Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab3IGT7y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 15:59:54 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:59680 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab3IGT7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 15:59:53 -0400
X-Auth-Info: cmr4/P2JeuDYJ88Ejq10Rb5eCixs2EfQuWk+Fk/5qsE=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpufreq: Fix wrong time unit conversion
References: <1378571708-27825-1-git-send-email-fweisbec@gmail.com>
X-Yow: I'm a fuschia bowling ball somewhere in Brittany
Date: Sat, 07 Sep 2013 21:59:38 +0200
In-Reply-To: <1378571708-27825-1-git-send-email-fweisbec@gmail.com> (Frederic
	Weisbecker's message of "Sat, 7 Sep 2013 18:35:08 +0200")
Message-ID: <87txhwh07p.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See also <http://permalink.gmane.org/gmane.linux.kernel.cpufreq/11672>.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
