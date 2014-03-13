Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaCMK6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:58:07 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:46420 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753673AbaCMK6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:58:05 -0400
Date: Thu, 13 Mar 2014 06:57:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH RT 4/4] Linux 3.2.55-rt81-rc
Message-ID: <20140313065758.3efee75c@gandalf.local.home>
In-Reply-To: <20140313104654.270838109@goodmis.org>
References: <20140313104626.944700242@goodmis.org>
	<20140313104654.270838109@goodmis.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014 06:46:30 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> index 5ba2c20..f9e9cc7 100644
> --- a/localversion-rt
> +++ b/localversion-rt
> @@ -1 +1 @@
> --rt80
> +-rt81-rc

Bah, that should have been -rt81-rc1. But it is rather pointless to
make an -rc2 to update the rc number.

-- Steve


