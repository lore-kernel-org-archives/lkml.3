Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842AbaFQMUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:20:39 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47927 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbaFQMUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:20:37 -0400
Message-ID: <1403007632.5652.8.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v2 0/3] KEYS: validate certificate trust with selected
 owner or builtin key
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, jwboyer@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 17 Jun 2014 08:20:32 -0400
In-Reply-To: <cover.1402994752.git.d.kasatkin@samsung.com>
References: <cover.1402994752.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061712-0928-0000-0000-000002B3E29E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-17 at 11:56 +0300, Dmitry Kasatkin wrote: 
> Instead of allowing public keys, with certificates signed by any key on
> the system trusted keyring, to be added to a trusted keyring, this patch
> set further restricts the certificates to those signed by a particular key
> or builtin keys on the system keyring.
> 
> This patch defines a new kernel parameter 'keys_ownerid={id: | builtin}'
> to use specific key or any builtin key.
> 
> Changes to v1:
> * key id matching code from asymmetric_type.c is reused in the patch

Nice!  The first two we'll upstream, but defer the builtin patch until
the UEFI key patches are upstreamed.

thanks,

Mimi

