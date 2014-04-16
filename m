Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbaDPUAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:00:19 -0400
Received: from www.meduna.org ([92.240.244.38]:55772 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbaDPUAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:00:16 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <534ED833.6020303@windriver.com>
References: <534E97C8.5090407@meduna.org> <534ED833.6020303@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Subject: Re: w1-gpio: sleeping function called from invalid context
From: Stanislav Meduna <stano@meduna.org>
Date: Wed, 16 Apr 2014 21:58:48 +0200
To: Paul Gortmaker <paul.gortmaker@windriver.com>, zbr@ioremap.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Message-ID: <0e38dfcf-df54-4b72-abf1-9b424af3f98b@email.android.com>
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2014-04-16 22:00:08
X-Connected-IP: 85.162.195.204:42930
X-Message-Linecount: 27
X-Body-Linecount: 14
X-Message-Size: 1093
X-Body-Size: 424
X-Received-Count: 1
X-Recipient-Count: 4
X-Local-Recipient-Count: 4
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On April 16, 2014 9:21:23 PM CEST, Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

>  static int w1_disable_irqs = 0;
>  module_param_named(disable_irqs, w1_disable_irqs, int, 0);
...
>I've no idea why that module parameter exists.  Why do you set it?

Hm... I do not, at least not knowingly. I'll try to trace what exactly happens.

Thanks
-- 
                                     Stano
