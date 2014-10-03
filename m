Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaJCOTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:19:38 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44768 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaJCOTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:19:36 -0400
Message-ID: <1412345967.5181.10.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 0/4] KEYS fixes
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, dhowells@redhat.com,
        jmorris@namei.org, rusty@rustcorp.com.au, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com
Date: Fri, 03 Oct 2014 10:19:27 -0400
In-Reply-To: <cover.1412327306.git.d.kasatkin@samsung.com>
References: <cover.1412327306.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100314-0928-0000-0000-00000553652E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-03 at 12:09 +0300, Dmitry Kasatkin wrote: 
> I reported yesterday problems with new KEYS.
> Module signature verification is broken, integrity subsystem verification is
> broken, kernel oopses.
> 
> Here is few fixes.

Thanks, Dmitry!  with these patch fixes, I'm now able to boot normally
with IMA-appraisal enabled in enforcing mode.

David, these two commits broke IMA-appraisal.  Either these patches need
to be reverted or the partial match needs to be re-introduced.  Dmitry's
patches do the latter.

757932e PKCS#7: Handle PKCS#7 messages that contain no X.509 certs
46963b7 KEYS: Overhaul key identification when searching for asymmetric
keys

Mimi

