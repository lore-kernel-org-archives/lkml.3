Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab3CENyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 08:54:15 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53684 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138Ab3CENyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 08:54:14 -0500
Message-ID: <1362491644.4392.161.camel@falcor1>
Subject: Re: [PATCH 2/6] ima: Return INTEGRITY_FAIL if digital signature
 can't be verified
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com
Date: Tue, 05 Mar 2013 08:54:04 -0500
In-Reply-To: <1362490253.4392.159.camel@falcor1>
References: <1360871745-20616-1-git-send-email-vgoyal@redhat.com>
	 <1360871745-20616-3-git-send-email-vgoyal@redhat.com>
	 <1362404916.4392.25.camel@falcor1> <20130304162033.GB15199@redhat.com>
	 <1362490253.4392.159.camel@falcor1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030513-7182-0000-0000-000005A57897
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 08:30 -0500, Mimi Zohar wrote:

> Digital signature verification happens using integrity_digsig_verify().
> If a digital signature is present in security.ima, then any error, which
> happens during signature verification, should lead to status
> INTEGRITY_FAIL.  In the future we might want to differentiate between
> persistent (eg. -ENOMEM) vs. non-persistent errors, in order to cache
> failures.  This patch removes the unnecessary -EOPNOTSUPP test.

correction, "persistent vs. non-persistent(eg. -ENOMEM)"

Mimi

